# RPNCalculator

This is a “scientific” RPN calculator for Mac OS X, which I created to teach a friend about Cocoa. The project was designed to use a lot of different Cocoa and Objective-C concepts while still being easy to follow and implement. Some of the concepts covered:

* Command-line arguments
* Cocoa scalars: `NSNumber` and `NSString`
* Cocoa collections: `NSArray` and `NSDictionary`
* Custom classes with public and private interfaces
* Dynamic behavior using `-performSelector:`
* Model-view-controller
* Target-action with `NSButton` and `NSSegmentedControl`
* Table views
* Protocols and delegation 
* Subclasses for specialization: `PGAlternateKeyButton`

`PGAlternateKeyButton` is an NSButton subclass whose instances change their title, target, action, and tag when the option (alternate) key is pressed. It’s probably the only thing in this project that can be reused. Just for fun, let’s think of this whole project as a ridiculous `PGAlternateKeyButton` example.


## Design

The project is split across two targets, rpncalc and RPNCalculator. Both use the `RPNCalculator` model class to actually do calculations, but provide very different UIs.  

rpncalc takes an expression from the command-line and calculates the result. The only part of this that is remotely interesting is how we map the CLI tokens, e.g., `acos`, `**`, and `lg`, to their respective `RPNCalculator` methods. Basically, we use three dictionaries to map the expression token to the selector; when we parse a token, we find its associated selector and execute it. This makes it really simple to support a ton of operations while still keeping our core CLI logic at around 50 lines.

The RPNCalculator target is a little more interesting. It’s a Mac OS X GUI version of the app. Our controller class `PGRPNCalculatorController` does almost all of the work there. 

We use a table view to display the calculator’s operand stack. Like other RPN calculator, this one fills in from the bottom-up, To get that to work, we basically assume that we have a fixed number R of visible rows in the table. If there are fewer than that many elements E in the calculator’s operand stack, we top-fill the first R - E rows with nothing. This is a lot easier than subclassing. The rest of the class just implements the correct number input behavior, which is much more of a pain than it would initially seem.

`PGRPNCalculatorController` also sets up some `PGAlternateKeyButton`s. This is so that secondary functions become available when you press the option key. For example, when you hold down option, sin turns into sin⁻¹. Exciting!

`PGAlternateKeyButton` is an incredibly simple class. It uses `NSEvent`’s local event monitor functionality to monitor keyboard events and test to see if the option key has been pressed. If so, it switches its title, target, action, and tag to their alternate versions. Otherwise, it just uses the button’s original values for those properties.


## License 

All code is licensed under the MIT license. Do with it as you will.
