## Read me first

- The Core framework used in this project is a collection of helpers and architectural niceties I've been working on for a while. It's a recent development that is meant for programmers (and me first of all) with SOLID principles, and I intend to structure it 1. according to Clean Architecture, 2. as reusable as possible. It is a work in progress, that I will use in a GraphQL project, so it will probablt go through some changes as previously it was used with standard URL session, supporting Swagger / OpenAPI definitions to integrate and use auto-generated API side code. You will find more on this in the following notes.

## Install notes

For external dependencies run

    carthage update --platform ios --configuration Debug --verbose
    

- For `realm-cocoa` there seemed to be a problem to build under MacOS Catalina,  the flag `--no-use-binaries` tells carthage to download the original, however `po` is broken by importing online libraries.  Haven't found a solution for this problem yet..


## App overview

The purpose of this application is to display, for demo purposes, the use of some core concepts and best practices I advocate as an ios consultant and engineer.


## SOLID, Protocols, TDD, VIPER 
- [This should be your bible](https://hackernoon.com/solid-principles-made-easy-67b1246bcdf)
- [This is a presentation I gave on tech debt](https://github.com/kerekesmarton/keynote-tech-debt-strategies)

### App Architecture

![High level architecture](App Architecure.png)

This architecture is aimed to provides a clear separation of concerns, giving way to scalable code. 

### VIPER

A feature doesn't necessarily require all of the stack components if it doesn't make sense. It might be that a component doesn't require a view, another doesn't require an interactor. It might be the case that a view requires two presenters (reusing one from a similar feature through composition) and it might be that a presenter requires 5 use cases, as such, 5 interactors. These can be then reused in other screens. See examples in Profile.

- **Rule of thumb** 1: Whenever you think you need a new component, first write a protocol. Makes you thinking cleaner. Ask yourself, how would you test it? Write a test that can only call the protocol's methods. Don't expose anything more.

- **Rule of thumb 2**: Always start from the domain layer. Think about your feature as a command line tool. It has to be called from the command line in a simple fashion, and should be able to print out the result. Not that it's going to be the case but again, it will simplify your thinking.

- **Rule of thumb 3**: High level modules should not depend upon low level modules. Both should depend on abstractions. Domain layer should never import Data, or Presentation, but declare its collaborating protocols. Data and Presentation should always implement these Data and Presentation should not know about each other. 

- **Rule of thumb 4**: UI components should never know what features they serve. A Cell or a label should not only server Profile or Channels. Instead, the ViewController can declare extensions of the UI Components that adapt it to a protocol declared by the presentation.

- **Rule of thumb 5**: ViewController should not ever contain any information that it presents, neither the cell. They can however have a reference to a presenting object that will be responsible for translating domain information to user information.

- **Rule of thumb 6**: Last but not least. Write a damn test after that protocol will ya? 

    Ex.: Presenter declares the protocol it requires to display a piece of information (a person in a list). View dequeues a cell conforming to this protocol and passes it to the presenter. IosCore Cell is abstract, but an extension on the cell, contained where the feature is located adapts the cell to conform to this protocol. Cell has it's own data model that requires a URL for image, String for titles, etc. Use separete cell data models for information arriving in discrete moments. One model for strings, another for error, another for images. Blocks for actions should be assigned separately. 

    This ensures that until the Presentation layer there is no need to know about UIKit, and all domain data stays above the ViewController.

    If we have to deploy to a new architecture, only IosCore needs to be duplicated for TvOS or WatchOS.

### Routers, Coordinator Pattern
- Routers serve their purpose as known in VIPER: starting the feature and managing the navigation stack. Creating new features.
- Routers by their nature are best to provide coordinator pattern in our app, this will simplify our lives later on. Every router implements 'Routing' to know about it's children. As such a network of routers provide a tree of responders who can each declare wheather they are able to respond to certain messages or deepLinks, or forward the message to their children.
- All routers know about their parents. If a message needs to be passed up the chain to a specific protocol, the router tree can do that.

### Dependency Injection, Modules
- Dependency injection is done via `Modules`. A `Module` would normally require a host to route on, while returning it's `Router` and  `ViewController`. The next `Router` has to be added to the calling router's children once it's started. 

### Style
- IosCore framework describes a styling protocol. Reusable components in here will try to infer some these styles and decorate themselves accordingly. 

- Implementation is provided in the app layer, as such every new client can have it's own style description.

### The need for frameworks.

Perhaps the first requirement is scalability. How many times have you seen a project become anightmare to maintain because of tech debt. As engineers we have to aim at creating easily scalable and supportable codebase.

Not respecting the above guidilenes is very easy, and deviating from it leads down the road where it's difficult to recover the tech debt. Keep on top of it!


### Core
- Additions
Syntax sugar

- Domain

        Business models and interactors. 
        Protocols collaborating with interactors

- Data

        Networking
        Persistence
        parsers for the above 
        service endpoints descriptions
        
- Presentation

        General non domain logic goes here.
        Abstraction for error & camera Routing and interaction presentation.
        App Presentation for startup and app lifecycle

        
- IosCore
        
        Routing implementation, App Router
        Default Error and Dialog presentation
        UIKit extensions
        Image Editor
        Notifications Displaying
        Style
        Reusable components
        
                
### Feature frameworks

- all features should go into framworks that don't know about each other.
- bespoke feature implementations go here

        ViewControllers
        Presenters
        Routers (Coordinators)
        Modules for Dependency injection
        
### Main App 

- main application is supposed to be very thin, only launches the feature frameworks and binds them togetether for dependency injection.

### 3rd party dependencies
        
- photo picker library    
        
        github "tilltue/TLPhotoPicker"
    
- persistence storage and used for reactive programming  

        github "realm/realm-cocoa"
    
- secure storage

        github "evgenyneu/keychain-swift"

- easy customisation of constraints

        github "SnapKit/SnapKit"

- image handling

        github "onevcat/Kingfisher"
    
- parsing JWT Tokens

        github "auth0/JWTDecode.swift"
        
- Network logging in DEBUG Reqres

        github "AckeeCZ/Reqres"
        
## Conventions
### Protocols and implementations
    
Protocols should be called *ing:
    
    "-Routing", "-Persisting", "-ProfileFetching", "-UserBlocking", etc.. 
    
Implementations should follow the -er convention:
        
     "-Router", "-Fetcher", "-Interactor", "-Presenter", etc..


