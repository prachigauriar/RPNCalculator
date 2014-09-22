//
//  main.m
//  rpncalc
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

#import "PGRPNCalculator.h"
#import "PGUtilities.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        if (argc == 1) {
            fprintf(stderr, "Usage: rpncalc expression\n");
            exit(1);
        }

        // These dictionaries map recognized operator tokens to their corresponding PGRPNCalculator selectors
        NSDictionary *uncheckedOperators = @{ @"roll" : @"rollOperandStackTowardsTop",
                                              @"rollBottom" : @"rollOperandStackTowardsBottom",
                                              @"rollTop" : @"rollOperandStackTowardsTop" };
        
        NSDictionary *unaryOperators = @{ @"acos" : @"arccosine",
                                          @"acosh" : @"inverseHyperbolicCosine",
                                          @"asin" : @"arcsine",
                                          @"asinh" : @"inverseHyperbolicSine",
                                          @"atan" : @"arctangent",
                                          @"atanh" : @"inverseHyperbolicTangent",
                                          @"cbrt" : @"cubeRoot",
                                          @"ceil" : @"ceiling",
                                          @"cos" : @"cosine",
                                          @"cosh" : @"hyperbolicCosine",
                                          @"floor" : @"floor",
                                          @"lg" : @"logBase2",
                                          @"ln" : @"logBaseE",
                                          @"log" : @"logBase10",
                                          @"round" : @"round",
                                          @"sin" : @"sine",
                                          @"sinh" : @"hyperbolicSine",
                                          @"sqrt" : @"squareRoot",
                                          @"tan" : @"tangent",
                                          @"tanh" : @"hyperbolicTangent",
                                          @"trunc" : @"truncate" };
        
        NSDictionary *binaryOperators = @{ @"+" : @"add",
                                           @"-" : @"subtract",
                                           @"*" : @"multiply",
                                           @"/" : @"divide",
                                           @"%" : @"modulo",
                                           @"**" : @"exponentialBaseY",
                                           @"logY" : @"logBaseY",
                                           @"swap" : @"swap" };
        
        PGRPNCalculator *calculator = [[PGRPNCalculator alloc] init];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.minimumIntegerDigits = 1;
        numberFormatter.maximumFractionDigits = 12;
        
        NSArray *arguments = [[[NSProcessInfo processInfo] arguments] subarrayWithRange:NSMakeRange(1, argc - 1)];
        NSString *expression = [arguments componentsJoinedByString:@" "];
        NSArray *tokens = [expression componentsSeparatedByString:@" "];
        
        printf("Evaluating expression: %s\n", [expression UTF8String]);

        // For each token in the expression
        for (NSString *token in tokens) {
            if ([token isEqualToString:@""]) {
                continue;
            }

            // Try to interpret the token as a number. If that works, push it and go to the next token
            NSNumber *number = [numberFormatter numberFromString:token];
            if (number) {
                [calculator pushNumber:number];
                continue;
            }

            // If the token is either deg or rad, change our radians/degrees mode and go to the next token
            if ([token isEqualToString:@"deg"]) {
                calculator.usesDegrees = YES;
                continue;
            } else if ([token isEqualToString:@"rad"]) {
                calculator.usesDegrees = NO;
                continue;
            }
            
            // Otherwise, try to find an operator for the token. If we find one but have too few operands, error out
            NSString *selectorString = uncheckedOperators[token];
            if ((!selectorString && (selectorString = unaryOperators[token]) && [calculator countOfOperandStack] < 1) ||
                (!selectorString && (selectorString = binaryOperators[token]) && [calculator countOfOperandStack] < 2)) {
                fprintf(stderr, "Too few operands on stack to perform %s. Exiting.\n", [token UTF8String]);
                exit(1);
            }
            
            // If we couldn't find an operator for the token, error out
            if (!selectorString) {
                fprintf(stderr, "Unknown operation %s. Exiting.\n", [token UTF8String]);
                exit(2);
            }

            // Otherwise perform the selector that corresponds to the operator
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [calculator performSelector:NSSelectorFromString(selectorString)];
#pragma clang diagnostic pop
        }
        
        // Once all tokens have been parsed, output the calculator's operand stack and quit
        for (NSNumber *number in [calculator operandStackEnumerator]) {
            printf("%s\n", [[numberFormatter stringFromNumber:number] UTF8String]);
        }
    }
    
    return 0;
}