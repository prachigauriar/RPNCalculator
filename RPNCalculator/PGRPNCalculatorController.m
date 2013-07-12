//
//  PGRPNCalculatorController.m
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

#import "PGRPNCalculatorController.h"

#import <math.h>

#import "PGRPNCalculator.h"
#import "PGAlternateKeyButton.h"


#pragma mark Constants

static const NSUInteger PGVisibleRowCount = 4;


#pragma mark - Private Interface

@interface PGRPNCalculatorController ()

@property(readwrite, retain) PGRPNCalculator *rpnCalculator;
@property(readwrite, retain) NSMutableString *inputString;

@property(readwrite, retain) NSNumberFormatter *numberFormatter;

@property(readwrite, assign) BOOL hasPushedPreviousResult;
@property(readwrite, assign) BOOL hasUpdatedOperand;

- (void)clearOperandIfNotUpdated;
- (void)pushPreviousResultIfNecessary;
- (double)inputStringDoubleValue;
- (NSUInteger)inputStringRowIndex;
- (void)scrollToInputStringRow;
- (void)pushInputString;
- (void)performUnaryOperation:(SEL)selector;
- (void)performBinaryOperation:(SEL)selector;

@end


#pragma mark - Implementation

@implementation PGRPNCalculatorController

- (id)init
{
    self = [super init];
    if (self) {
        self.rpnCalculator = [[PGRPNCalculator alloc] init];

        self.inputString = [[NSMutableString alloc] initWithString:@"0"];
        self.hasPushedPreviousResult = YES;
        
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        [self.numberFormatter setMinimumIntegerDigits:1];
        [self.numberFormatter setMaximumFractionDigits:12];
    }
    
    return self;
}


- (void)awakeFromNib
{
    self.divideModButton.alternateKeyTitle = @"Mod";
    self.divideModButton.alternateKeyTarget = self;
    self.divideModButton.alternateKeyAction = @selector(mod:);
  
    self.exp2LgButton.alternateKeyTitle = @"lg";
    self.exp2LgButton.alternateKeyTarget = self;
    self.exp2LgButton.alternateKeyAction = @selector(lg:);

    self.expELnButton.alternateKeyTitle = @"ln";
    self.expELnButton.alternateKeyTarget = self;
    self.expELnButton.alternateKeyAction = @selector(ln:);

    self.exp10LogButton.alternateKeyTitle = @"log";
    self.exp10LogButton.alternateKeyTarget = self;
    self.exp10LogButton.alternateKeyAction = @selector(log:);

    self.squaredCubedButton.alternateKeyTitle = @"x³";
    self.squaredCubedButton.alternateKeyTarget = self;
    self.squaredCubedButton.alternateKeyAction = @selector(cube:);

    self.squareRootCubeRootButton.alternateKeyTitle = @"∛";
    self.squareRootCubeRootButton.alternateKeyTarget = self;
    self.squareRootCubeRootButton.alternateKeyAction = @selector(cubeRoot:);

    self.roundTruncButton.alternateKeyTitle = @"Trunc";
    self.roundTruncButton.alternateKeyTarget = self;
    self.roundTruncButton.alternateKeyAction = @selector(trunc:);

    self.floorCeilButton.alternateKeyTitle = @"Ceil";
    self.floorCeilButton.alternateKeyTarget = self;
    self.floorCeilButton.alternateKeyAction = @selector(ceil:);

    self.rollDownRollUpButton.alternateKeyTitle = @"Roll ↑";
    self.rollDownRollUpButton.alternateKeyTarget = self;
    self.rollDownRollUpButton.alternateKeyAction = @selector(rollUp:);

    self.clearAllClearButton.alternateKeyTitle = @"AC";
    self.clearAllClearButton.alternateKeyTarget = self;
    self.clearAllClearButton.alternateKeyAction = @selector(clearAll:);

    self.sinArcsinButton.alternateKeyTitle = @"sin⁻¹";
    self.sinArcsinButton.alternateKeyTarget = self;
    self.sinArcsinButton.alternateKeyAction = @selector(arcsin:);

    self.cosArccosButton.alternateKeyTitle = @"cos⁻¹";
    self.cosArccosButton.alternateKeyTarget = self;
    self.cosArccosButton.alternateKeyAction = @selector(arccos:);

    self.tanArctanButton.alternateKeyTitle = @"tan⁻¹";
    self.tanArctanButton.alternateKeyTarget = self;
    self.tanArctanButton.alternateKeyAction = @selector(arctan:);
}


#pragma mark - Private Methods

- (void)clearOperandIfNotUpdated
{
    if (self.hasUpdatedOperand) return;
    [self.inputString deleteCharactersInRange:NSMakeRange(0, self.inputString.length)];
    self.hasUpdatedOperand = YES;
}


- (void)pushPreviousResultIfNecessary
{
    if (self.hasPushedPreviousResult) return;
    [self pushInputString];
    self.hasPushedPreviousResult = YES;
}


- (double)inputStringDoubleValue
{
    return [[self.numberFormatter numberFromString:self.inputString] doubleValue];
}


- (NSUInteger)inputStringRowIndex
{
    NSUInteger operandStackDepth = [self.rpnCalculator countOfOperandStack];
    return (operandStackDepth >= PGVisibleRowCount) ? operandStackDepth : PGVisibleRowCount - 1;
}


- (void)scrollToInputStringRow
{
    [self.stackTableView scrollRowToVisible:[self inputStringRowIndex]];
}

- (void)pushInputString
{
    [self.rpnCalculator pushNumber:[self.numberFormatter numberFromString:self.inputString]];
    self.hasUpdatedOperand = NO;
}


- (void)performUnaryOperation:(SEL)selector
{
    [self pushInputString];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.rpnCalculator performSelector:selector];
#pragma clang diagnostic pop
    
    [self.inputString setString:[self.numberFormatter stringFromNumber:[self.rpnCalculator popNumber]]];
    self.hasPushedPreviousResult = NO;
    [self.stackTableView reloadData];
    [self scrollToInputStringRow];
}


- (void)performBinaryOperation:(SEL)selector
{
    if ([self.rpnCalculator countOfOperandStack] == 0) {
        NSBeep();
        return;
    }
    
    [self pushInputString];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.rpnCalculator performSelector:selector];
#pragma clang diagnostic pop
    
    [self.inputString setString:[self.numberFormatter stringFromNumber:[self.rpnCalculator popNumber]]];
    self.hasPushedPreviousResult = NO;
    [self.stackTableView reloadData];
    [self scrollToInputStringRow];
}


#pragma mark - Input String Manipulation

- (IBAction)appendDigit:(id)sender
{
    NSUInteger digit = [sender tag];
    if (digit == 0 && [self.inputString isEqualToString:@"0"]) return;
        
    [self pushPreviousResultIfNecessary];
    [self clearOperandIfNotUpdated];
    if ([self.inputString isEqualToString:@"0"]) {
        [self.inputString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    [self.inputString appendFormat:@"%ld", digit];
    [self.stackTableView reloadData];
    [self scrollToInputStringRow];
}


- (IBAction)appendDecimalPoint:(id)sender
{
    [self pushPreviousResultIfNecessary];
    [self clearOperandIfNotUpdated];
    NSRange decimalPointRange = [self.inputString rangeOfString:@"."];
    if (decimalPointRange.location != NSNotFound) {
        NSBeep();
        return;
    }
    
    [self.inputString appendString:(self.inputString.length == 0 ? @"0." : @".")];
    [self.stackTableView reloadData];
    [self scrollToInputStringRow];
}


- (IBAction)clear:(id)sender
{
    [self.inputString setString:@"0"];
    self.hasPushedPreviousResult = YES;
    self.hasUpdatedOperand = NO;
    [self.stackTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:[self inputStringRowIndex]]
                                   columnIndexes:[NSIndexSet indexSetWithIndex:0]];
}


- (IBAction)clearAll:(id)sender
{
    NSUInteger stackDepth = [self.rpnCalculator countOfOperandStack];
    while(stackDepth--) {
        [self.rpnCalculator popNumber];
    }
    
    [self.inputString setString:@"0"];
    self.hasPushedPreviousResult = YES;
    self.hasUpdatedOperand = NO;
    [self.stackTableView reloadData];
}


- (IBAction)delete:(id)sender
{
    if (!self.hasPushedPreviousResult) {
        [self clear:self];
        return;
    }
    
    [self clearOperandIfNotUpdated];

    if (self.inputString.length > 0) {
        [self.inputString deleteCharactersInRange:NSMakeRange(self.inputString.length - 1, 1)];
    }

    if (self.inputString.length == 0 || [self.inputString isEqualToString:@"-"]) {
        [self.inputString setString:@"0"];
    }

    [self.stackTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:[self inputStringRowIndex]]
                                   columnIndexes:[NSIndexSet indexSetWithIndex:0]];
}


- (IBAction)drop:(id)sender
{
    if ([self.rpnCalculator countOfOperandStack] != 0) {
        NSNumber *number = [self.rpnCalculator popNumber];
        [self.inputString setString:[self.numberFormatter stringFromNumber:number]];
        self.hasPushedPreviousResult = NO;
    } else {
        [self.inputString setString:@"0"];
        self.hasPushedPreviousResult = YES;
    }

    self.hasUpdatedOperand = NO;
    [self.stackTableView reloadData];
    [self scrollToInputStringRow];
}


- (IBAction)rollDown:(id)sender
{
    [self performBinaryOperation:@selector(rollOperandStackTowardsTop)];
}


- (IBAction)rollUp:(id)sender
{
    [self performBinaryOperation:@selector(rollOperandStackTowardsBottom)];
}


- (IBAction)submit:(id)sender
{
    [self pushInputString];
    self.hasPushedPreviousResult = YES;
    [self.stackTableView reloadData];
    [self scrollToInputStringRow];
}


- (IBAction)swap:(id)sender
{
    [self performBinaryOperation:@selector(swap)];
}


#pragma mark - Operations

- (IBAction)round:(id)sender
{
    [self performUnaryOperation:@selector(round)];
}


- (IBAction)trunc:(id)sender
{
    [self performUnaryOperation:@selector(truncate)];
}


- (IBAction)floor:(id)sender
{
    [self performUnaryOperation:@selector(floor)];
}


- (IBAction)ceil:(id)sender
{
    [self performUnaryOperation:@selector(ceiling)];
}


- (IBAction)add:(id)sender
{    
    [self performBinaryOperation:@selector(add)];
}


- (IBAction)subtract:(id)sender
{
    [self performBinaryOperation:@selector(subtract)];
}


- (IBAction)multiply:(id)sender
{
    [self performBinaryOperation:@selector(multiply)];
}


- (IBAction)divide:(id)sender
{
    if ([self inputStringDoubleValue] == 0.0) {
        NSBeep();
        return;
    }
    
    [self performBinaryOperation:@selector(divide)];
}


- (IBAction)mod:(id)sender
{
    if ([self inputStringDoubleValue] == 0.0) {
        NSBeep();
        return;
    }
    
    [self performBinaryOperation:@selector(modulo)];
}


- (IBAction)negate:(id)sender
{
    if ([self.inputString isEqualToString:@"0"]) {
        NSBeep();
        return;
    }
    
    if ([self.inputString hasPrefix:@"-"]) {
        [self.inputString deleteCharactersInRange:NSMakeRange(0, 1)];
    } else {
        [self.inputString insertString:@"-" atIndex:0];
    }

    self.hasUpdatedOperand = YES;
    [self.stackTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:[self inputStringRowIndex]]
                                   columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    [self scrollToInputStringRow];
}


- (IBAction)square:(id)sender
{
    [self performUnaryOperation:@selector(square)];
}


- (IBAction)squareRoot:(id)sender
{
    if ([self inputStringDoubleValue] < 0) {
        NSBeep();
        return;
    }
    
    [self performUnaryOperation:@selector(squareRoot)];
}


- (IBAction)cube:(id)sender
{
    [self performUnaryOperation:@selector(cube)];
}


- (IBAction)cubeRoot:(id)sender
{
    [self performUnaryOperation:@selector(cubeRoot)];
}


- (IBAction)ln:(id)sender
{
    if ([self inputStringDoubleValue] <= 0) {
        NSBeep();
        return;
    }

    [self performUnaryOperation:@selector(logBaseE)];
}


- (IBAction)expE:(id)sender
{
    [self performUnaryOperation:@selector(exponentialBaseE)];
}


- (IBAction)lg:(id)sender
{
    if ([self inputStringDoubleValue] <= 0) {
        NSBeep();
        return;
    }

    [self performUnaryOperation:@selector(logBase2)];
}


- (IBAction)exp2:(id)sender
{
    [self performUnaryOperation:@selector(exponentialBase2)];
}


- (IBAction)log:(id)sender
{
    if ([self inputStringDoubleValue] <= 0) {
        NSBeep();
        return;
    }
    
    [self performUnaryOperation:@selector(logBase10)];
}


- (IBAction)exp10:(id)sender
{
    [self performUnaryOperation:@selector(exponentialBase10)];
}


- (IBAction)expY:(id)sender
{
    [self performBinaryOperation:@selector(exponentialBaseY)];
}


- (IBAction)sin:(id)sender
{
    [self performUnaryOperation:@selector(sine)];
}


- (IBAction)arcsin:(id)sender
{
    double x = [self inputStringDoubleValue];
    if (x < -1 || x > 1) {
        NSBeep();
        return;
    }
        
    [self performUnaryOperation:@selector(arcsine)];
}


- (IBAction)cos:(id)sender
{
    [self performUnaryOperation:@selector(cosine)];
}


- (IBAction)arccos:(id)sender
{
    double x = [self inputStringDoubleValue];
    if (x < -1 || x > 1) {
        NSBeep();
        return;
    }

    [self performUnaryOperation:@selector(arccosine)];
}


- (IBAction)tan:(id)sender
{
    [self performUnaryOperation:@selector(tangent)];
}


- (IBAction)arctan:(id)sender
{
    [self performUnaryOperation:@selector(arctangent)];
}


#pragma mark - Constant Insertion

- (IBAction)insertConstantE:(id)sender
{
    [self pushPreviousResultIfNecessary];
    [self clearOperandIfNotUpdated];
    [self.inputString setString:[self.numberFormatter stringFromNumber:@(M_E)]];
    [self.stackTableView reloadData];
}


- (IBAction)insertConstantPi:(id)sender
{
    [self pushPreviousResultIfNecessary];
    [self clearOperandIfNotUpdated];
    [self.inputString setString:[self.numberFormatter stringFromNumber:@(M_PI)]];
    [self.stackTableView reloadData];
}


#pragma mark - Other Action Methods

- (IBAction)radianDegreeModeChanged:(id)sender
{
    self.rpnCalculator.usesDegrees = ([sender selectedSegment] == 1);
}


#pragma mark - Table View data source and delegate methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSUInteger rowCount = [self.rpnCalculator countOfOperandStack] + 1;
    return rowCount >= PGVisibleRowCount ? rowCount : PGVisibleRowCount;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSUInteger rowCount = [self.rpnCalculator countOfOperandStack] + 1;

    // If we have PGVisibleRowCount or more rows, we just make sure that the last item is the operand
    if (rowCount >= PGVisibleRowCount) {
        return (row == rowCount - 1) ? self.inputString : [self.numberFormatter stringFromNumber:[self.rpnCalculator objectInOperandStackAtIndex:row]];
    }
    
    if (row < PGVisibleRowCount - rowCount) {
        // If we have fewer than PGVisibleRowCount rows, put empty rows in at the top
        return nil;
    } else if (row < PGVisibleRowCount - 1) {
        // PGVisibleRowCount - countOfOperandStack <= row < PGVisibleRowCount - 1
        return [self.numberFormatter stringFromNumber:[self.rpnCalculator objectInOperandStackAtIndex:(rowCount - PGVisibleRowCount) + row]];
    } else {
        // The last visible row is the input string
        return self.inputString;
    }
}


- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    return NO;
}


#pragma mark - Application delegate methods

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}


@end
