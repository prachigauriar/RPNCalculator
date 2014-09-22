//
//  PGRPNCalculator.h
//  RPNCalculator
//
//  Created by Prachi Gauriar on 1/25/2013.
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

#import <Foundation/Foundation.h>

@interface PGRPNCalculator : NSObject

@property (nonatomic, assign) BOOL usesDegrees;

@property (nonatomic, readonly) NSUInteger countOfOperandStack;
@property (nonatomic, readonly, strong) NSEnumerator *operandStackEnumerator;
@property (nonatomic, readonly, strong) NSEnumerator *operandStackReverseEnumerator;


#pragma mark - Operand Stack Management

- (void)insertObject:(NSNumber *)number inOperandStackAtIndex:(NSUInteger)index;
- (NSNumber *)objectInOperandStackAtIndex:(NSUInteger)index;
- (void)replaceObjectInOperandStackAtIndex:(NSUInteger)index withObject:(NSNumber *)object;
- (void)removeObjectFromOperandStackAtIndex:(NSUInteger)index;

- (void)pushNumber:(NSNumber *)number;
- (NSNumber *)popNumber;

- (NSNumber *)xValue;
- (NSNumber *)yValue;

- (void)swap;
- (void)rollOperandStackTowardsTop;
- (void)rollOperandStackTowardsBottom;

#pragma mark - Basic Operations

- (void)add;
- (void)subtract;
- (void)multiply;
- (void)divide;
- (void)modulo;

# pragma mark - Rounding and truncation

- (void)round;
- (void)truncate;
- (void)floor;
- (void)ceiling;

#pragma mark - Logarithms

- (void)logBaseE;
- (void)logBase2;
- (void)logBase10;
- (void)logBaseY;

#pragma mark - Exponentiation

- (void)exponentialBaseE;
- (void)exponentialBase2;
- (void)exponentialBase10;
- (void)exponentialBaseY;

- (void)square;
- (void)squareRoot;
- (void)cube;
- (void)cubeRoot;

#pragma mark - Trigonometric Functions

- (void)sine;
- (void)cosine;
- (void)tangent;

- (void)arcsine;
- (void)arccosine;
- (void)arctangent;

- (void)hyperbolicSine;
- (void)hyperbolicCosine;
- (void)hyperbolicTangent;

- (void)inverseHyperbolicSine;
- (void)inverseHyperbolicCosine;
- (void)inverseHyperbolicTangent;

@end
