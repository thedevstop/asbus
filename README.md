asbus
=====

An easy to use Command and Query Bus.

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
	private var _id:String;
	private var _name:String;
	private var _passwordHash:String;

	public function RegisterUserCommand(id:String, name:String, passwordHash:String)
	{
		this._id = id;
		this._name = name;
		this._passwordHash = passwordHash;
	}
	
	public function get id():String
	{
		return this._id;
	}
	
	public function get name():String
	{
		return this._name;
	}
	
	public function get passwordHash():String
	{
		return this._passwordHash;
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
	private var _id:String;

	public function GetUserQuery(id:String)
	{
		this._id = id;
	}
	
	public function get id():String
	{
		return this._id;
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

	protected override function handleQuery(query:*):Promise
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

**License**

This content is released under the MIT License (See LICENSE.txt).
