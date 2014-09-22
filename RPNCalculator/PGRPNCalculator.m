//
//  PGRPNCalculator.m
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

#import "PGRPNCalculator.h"


#pragma mark Constants

static const double PGRadiansToDegreesFactor = 180 / M_PI;
static const double PGDegreesToRadiansFactor = M_PI / 180;


#pragma mark - Private Interface

@interface PGRPNCalculator ()

@property (nonatomic, strong) NSMutableArray *operandStack;

- (double)popDouble;
- (double)popAngleAsDouble;
- (void)pushDoubleInRadians:(double)doubleInRadians;

@end


#pragma mark - Implementation

@implementation PGRPNCalculator

+ (PGRPNCalculator *)RPNCalculator
{
    return [[self alloc] init];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark - Operand Stack Management

- (NSUInteger)countOfOperandStack
{
    return [self.operandStack count];
}


- (void)insertObject:(NSNumber *)number inOperandStackAtIndex:(NSUInteger)index
{
    [self.operandStack insertObject:number atIndex:index];
}


- (NSNumber *)objectInOperandStackAtIndex:(NSUInteger)index
{
    return self.operandStack[index];
}


- (void)replaceObjectInOperandStackAtIndex:(NSUInteger)index withObject:(NSNumber *)number
{
    self.operandStack[index] = number;
}


- (void)removeObjectFromOperandStackAtIndex:(NSUInteger)index
{
    [self.operandStack removeObjectAtIndex:index];
}


- (NSEnumerator *)operandStackEnumerator
{
    return [self.operandStack objectEnumerator];
}


- (NSEnumerator *)operandStackReverseEnumerator
{
    return [self.operandStack reverseObjectEnumerator];
}


- (void)pushNumber:(NSNumber *)number
{
    [self insertObject:number inOperandStackAtIndex:self.countOfOperandStack];
}


- (void)pushDoubleInRadians:(double)doubleInRadians
{
    [self pushNumber:@(self.usesDegrees ? doubleInRadians * PGRadiansToDegreesFactor : doubleInRadians)];
}


- (NSNumber *)popNumber
{
    NSNumber *number = [self xValue];
    [self removeObjectFromOperandStackAtIndex:self.countOfOperandStack - 1];
    return number;
}


- (double)popDouble
{
    return [[self popNumber] doubleValue];
}


- (double)popAngleAsDouble
{
    return self.usesDegrees ? [self popDouble] * PGDegreesToRadiansFactor : [self popDouble];
}


- (NSNumber *)xValue
{
    return [self objectInOperandStackAtIndex:self.countOfOperandStack - 1];
}


- (NSNumber *)yValue
{
    return [self objectInOperandStackAtIndex:self.countOfOperandStack - 2];
}


- (void)swap
{
    NSNumber *x = [self popNumber];
    NSNumber *y = [self popNumber];
    [self pushNumber:x];
    [self pushNumber:y];
}


- (void)rollOperandStackTowardsTop
{
    if (self.countOfOperandStack < 2) {
        return;
    }

    [self insertObject:[self popNumber] inOperandStackAtIndex:0];
}


- (void)rollOperandStackTowardsBottom
{
    if (self.countOfOperandStack < 2) {
        return;
    }

    NSNumber *bottom = [self objectInOperandStackAtIndex:0];
    [self removeObjectFromOperandStackAtIndex:0];
    [self pushNumber:bottom];
}


#pragma mark - Basic Operations

- (void)add
{
    [self pushNumber:@([self popDouble] + [self popDouble])];
}


- (void)subtract
{
    double x = [self popDouble];
    double y = [self popDouble];
    [self pushNumber:@(y - x)];
}


- (void)multiply
{
    [self pushNumber:@([self popDouble] * [self popDouble])];
}


- (void)divide
{
    double x = [self popDouble];
    double y = [self popDouble];
    if (y == 0) {
        [self pushNumber:@(INFINITY)];
        return;
    }
    
    [self pushNumber:@(y / x)];
}


- (void)modulo
{
    double x = [self popDouble];
    double y = [self popDouble];
    if (y == 0) {
        [self pushNumber:@(NAN)];
        return;
    }

    [self pushNumber:@(fmod(y, x))];
}


#pragma mark - Rounding and truncation

- (void)round
{
    [self pushNumber:@(round([self popDouble]))];
}


- (void)truncate
{
    [self pushNumber:@(trunc([self popDouble]))];
}


- (void)floor
{
    [self pushNumber:@(floor([self popDouble]))];
}


- (void)ceiling
{
    [self pushNumber:@(ceil([self popDouble]))];
}


#pragma mark - Logarithms

- (void)logBaseE
{
    double x = [self popDouble];
    if (x < 0) {
        [self pushNumber:@(NAN)];
        return;
    }
    
    [self pushNumber:@(log(x))];
}


- (void)logBase2
{
    double x = [self popDouble];
    if (x < 0) {
        [self pushNumber:@(NAN)];
        return;
    }
    
    [self pushNumber:@(log2(x))];
}


- (void)logBase10
{
    double x = [self popDouble];
    if (x < 0) {
        [self pushNumber:@(NAN)];
        return;
    }
    
    [self pushNumber:@(log10(x))];
    
}


- (void)logBaseY
{
    double x = [self popDouble];
    double y = [self popDouble];
    if (x < 0 || y <= 0 || y == 1) {
        [self pushNumber:@(NAN)];
        return;
    }
    
    [self pushNumber:@(log(x) / log(y))];
}


#pragma mark - Exponentiation

- (void)exponentialBaseE
{
    [self pushNumber:@(exp([self popDouble]))];
}


- (void)exponentialBase2
{
    [self pushNumber:@(exp2([self popDouble]))];
}


- (void)exponentialBase10
{
    [self pushNumber:@(pow(10, [self popDouble]))];
}


- (void)exponentialBaseY
{
    double x = [self popDouble];
    double y = [self popDouble];
    [self pushNumber:@(pow(y, x))];
}


- (void)square
{
    double x = [self popDouble];
    [self pushNumber:@(x * x)];
}


- (void)squareRoot
{
    double x = [self popDouble];
    if (x < 0) {
        [self pushNumber:@(NAN)];
        return;
    }
    
    [self pushNumber:@(sqrt(x))];
}


- (void)cube
{
    double x = [self popDouble];
    [self pushNumber:@(x * x * x)];
}


- (void)cubeRoot
{
    double x = [self popDouble];
    [self pushNumber:@(cbrt(x))];
}


#pragma mark - Trigonometric Functions

- (void)sine
{
    [self pushNumber:@(sin([self popAngleAsDouble]))];
}


- (void)cosine
{
    [self pushNumber:@(cos([self popAngleAsDouble]))];
}


- (void)tangent
{
    [self pushNumber:@(tan([self popAngleAsDouble]))];
}


- (void)arcsine
{
    double x = [self popDouble];
    if (fabs(x) > 1) {
        [self pushNumber:@(NAN)];
        return;
    }
    
    [self pushDoubleInRadians:asin(x)];
}


- (void)arccosine
{
    double x = [self popDouble];
    if (fabs(x) > 1) {
        [self pushNumber:@(NAN)];
        return;
    }
    
    [self pushDoubleInRadians:acos(x)];
}


- (void)arctangent
{
    [self pushDoubleInRadians:atan([self popDouble])];
}


- (void)hyperbolicSine
{
    [self pushNumber:@(sinh([self popDouble]))];
}


- (void)hyperbolicCosine
{
    [self pushNumber:@(cosh([self popDouble]))];
}


- (void)hyperbolicTangent
{
    [self pushNumber:@(tanh([self popDouble]))];
}


- (void)inverseHyperbolicSine
{
    [self pushNumber:@(asinh([self popDouble]))];
}


- (void)inverseHyperbolicCosine
{
    double x = [self popDouble];
    if (x < 1) {
        [self pushNumber:@(NAN)];
        return;
    }
    
    [self pushNumber:@(acosh(x))];
}


- (void)inverseHyperbolicTangent
{
    double x = [self popDouble];
    double absX = fabs(x);

    if (absX == 1) {
        [self pushNumber:@(INFINITY)];
        return;
    } else if (absX > 1) {
        [self pushNumber:@(NAN)];
        return;
    }
    
    [self pushNumber:@(atanh(x))];
}

@end
