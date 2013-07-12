//
//  PGRPNCalculatorController.h
//  RPNCalculator
//
//  Created by Prachi Gauriar on 1/26/2013.
//  Copyright (c) 2013 Prachi Gauriar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Cocoa/Cocoa.h>

@class PGRPNCalculator, PGAlternateKeyButton;

@interface PGRPNCalculatorController : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (weak, nonatomic) IBOutlet NSWindow *window;
@property (weak, nonatomic) IBOutlet NSTableView *stackTableView;

@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *divideModButton;
@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *exp2LgButton;
@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *expELnButton;
@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *exp10LogButton;
@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *squaredCubedButton;
@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *squareRootCubeRootButton;
@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *roundTruncButton;
@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *floorCeilButton;
@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *rollDownRollUpButton;
@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *clearAllClearButton;
@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *sinArcsinButton;
@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *cosArccosButton;
@property (weak, nonatomic) IBOutlet PGAlternateKeyButton *tanArctanButton;


- (IBAction)appendDigit:(id)sender;
- (IBAction)appendDecimalPoint:(id)sender;

- (IBAction)clear:(id)sender;
- (IBAction)clearAll:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)drop:(id)sender;
- (IBAction)rollUp:(id)sender;
- (IBAction)rollDown:(id)sender;
- (IBAction)submit:(id)sender;
- (IBAction)swap:(id)sender;

- (IBAction)round:(id)sender;
- (IBAction)trunc:(id)sender;
- (IBAction)floor:(id)sender;
- (IBAction)ceil:(id)sender;

- (IBAction)add:(id)sender;
- (IBAction)subtract:(id)sender;
- (IBAction)multiply:(id)sender;
- (IBAction)divide:(id)sender;
- (IBAction)mod:(id)sender;
- (IBAction)negate:(id)sender;

- (IBAction)square:(id)sender;
- (IBAction)cube:(id)sender;
- (IBAction)squareRoot:(id)sender;
- (IBAction)cubeRoot:(id)sender;
- (IBAction)expE:(id)sender;
- (IBAction)ln:(id)sender;
- (IBAction)exp2:(id)sender;
- (IBAction)lg:(id)sender;
- (IBAction)exp10:(id)sender;
- (IBAction)log:(id)sender;
- (IBAction)expY:(id)sender;

- (IBAction)sin:(id)sender;
- (IBAction)arcsin:(id)sender;
- (IBAction)cos:(id)sender;
- (IBAction)arccos:(id)sender;
- (IBAction)tan:(id)sender;
- (IBAction)arctan:(id)sender;

- (IBAction)radianDegreeModeChanged:(id)sender;

- (IBAction)insertConstantE:(id)sender;
- (IBAction)insertConstantPi:(id)sender;

@end
