asbus
=====

An easy to use Command and Query Bus library with basic event sourcing support.

**Mediator**

The mediator serves dual purpose as both the Command Bus and the Query Bus.

``` actionscript
var id:String = generateGuid();
var name:String = "New User";
var passwordHash:String = MD5.calculate(password);

var mediator:IMediator = factory.resolve(IMediator);
mediator.send(new RegisterUserCommand(id, name, passwordHash));
mediator.request(new GetUserQuery(id)).then(
	function onFulfilled (user:User):* {
		// use the user here
	},
	function onRejected (error:Error):* {
		// report error here
	});
```

In order for the mediator to know which Handler to use for each Command or Query, the Handler must be registered with the IoC container.

``` actionscript
factory.inScope(RegisterUserCommand).register(RegisterUserHandler).asType(ICommandHandler);
factory.inScope(GetUserQuery).register(GetUserHandler).asType(IQueryHandler);
```

***

**Commands**

Commands are simple value objects that carry the state needed by the CommandHandler.

``` actionscript
public class RegisterUserCommand extends Command
{
	public var id:String;
	public var name:String;
	public var passwordHash:String;

	public function RegisterUserCommand(id:String, name:String, passwordHash:String)
	{
		this.id = id;
		this.name = name;
		this.passwordHash = passwordHash;
	}
}
```

The CommandHandler mutates global state without any return value.

``` actionscript
public class RegisterUserHandler extends CommandHandler
{
	private var _userRepository:IUserRepository;

    public function RegisterUserHandler(userRepository:IUserRepository)
    {
    	// Registers the supported Command class
		super(RegisterUserCommand);

		_userRepository = userRepository;
	}

	protected override function handleCommand(command:*):void
	{
		var user:RegisterUserCommand = command;
		_userRepository.add(user.id, user.name, user.passwordHash);
	}
}
```

***

**Queries**

Queries are simple value objects that carry the state needed by the QueryHandler.

``` actionscript
public class GetUserQuery extends Query
{
	public var id:String;

	public function GetUserQuery(id:String)
	{
		this.id = id;
	}
}
```

The QueryHandler returns the Promise of a value without mutating global state.

``` actionscript
public class GetUserHandler extends QueryHandler
{
	private var _userRepository:IUserRepository;

	public function GetUserHandler(userRepository:IUserRepository)
	{
		// Registers the supported Query class
		super(GetUserQuery);

		_userRepository = userRepository;
	}

	protected override function handleQuery(query:*):void
	{
		var user:GetUserQuery = query;
		return Promise.when(_userRepository.get(user.id));
	}
}
```

***

**Promises**

Promises represent a future value; i.e., a value that may not yet be available. A Promise's `then()` method is used to specify `onFulfilled` and `onRejected` callbacks that will be notified when the future value becomes available.

``` actionscript
var promise:Promise = mediator.request(new GetUserQuery(id));
promise.then(
	function onFulfilled (user:User):* {
		// use the user here
	},
	function onRejected (error:Error):* {
		// report error here
	});
```

Asbus uses [promise-as3](https://github.com/CodeCatalyst/promise-as3 "promise-as3") for it's Promise implementation.

***

**IoC Container**

The IoC container is used for binding object together at runtime. In addition to being the platform for registering Commands and Queries, it will also resolve the dependencies used by the Handlers.

``` actionscript
var factory:FluentAsFactory = new FluentAsFactory();
factory.register(InMemoryUserRepository).asType(IUserRepository).asSingleton();

factory.inScope(GetUserQuery).register(GetUserHandler).asType(IQueryHandler);
var handler:IQueryHandler = factory.fromScope(GetUserQuery).resolve(IQueryHandler);

// The handler variable is an instance of GetUserHandler which required an IUserRepository in its constructor.
// The IoC container passed an singleton instance of the InMemoryUserRepository into the GetUserHandler constructor to fulfill this dependency.
```

Asbus uses [asfac](https://github.com/thedevstop/asfac/ "asfac") for it's IoC container.

***

**Event Sourcing**

Domain Events

Unlike ActionScript events that notify anyone listening about changes in state. Domain events represent changes in state internal to an Aggregate.

``` actionscript
public class UserNameChanged extends DomainEvent
{
	public var newName:String;
	
	public function UserNameChanged(newName:String)
	{
		this.newName = newName;
	}
}
```

Event-sourced Aggregate

Represents a domain model whose internal state is composed of Domain Events.

``` actionscript
public class User extends EventSourcedAggregate
{
	private var _id:String;
	private var _name:String;
	private var _passwordHash:String;

	public function User()
	{
		// Register the events this Aggregate can process.
		register(UserCreated, whenCreated);
		register(UserNameChanged, whenNameChanged);
		register(UserPasswordChanged, whenPasswordChanged);
	}
	
	public function get id():String
	{
		return _id;
	}
	
	public function get name():String
	{
		return _name;
	}
	
	public function set name(newName:String):void
	{
		apply(new UserNameChanged(newName));
	}
	
	public function validatePassword(attemptedPassword:String):Boolean
	{
		var attemptedPasswordHash:String = MD5.calculate(attemptedPassword);
		return _passwordHash === attemptedPasswordHash;
	}
	
	public function set password(newPassword:String):void
	{
		var newPasswordHash:String = MD5.calculate(newPassword);
		apply(new UserPasswordChanged(newPasswordHash));
	}
	
	private function whenCreated(event:UserCreated):void
	{
		_id = event.id;
		_name = event.name;
		_passwordHash = event.passwordHash;
	}

	private function whenNameChanged(event:UserNameChanged):void
	{
		_name = event.newName;
	}
	
	private function whenPasswordChanged(event:UserPasswordChanged):void
	{
		_passwordHash = event.newPasswordHash;
	}
}
```

***

**License**

This content is released under the MIT License (See LICENSE.txt).
