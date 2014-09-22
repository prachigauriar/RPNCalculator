//
//  PGAlternateKeyButton.m
//  RPNCalculator
//
//  Created by Prachi Gauriar on 1/27/2013.
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

#import "PGAlternateKeyButton.h"

@interface PGAlternateKeyButton ()

@property (nonatomic, assign) BOOL usesAlternateKeyProperties;
@property (strong, nonatomic) id eventMonitor;

@property (nonatomic, copy) NSString *originalTitle;
@property (nonatomic, strong) id originalTarget;
@property (nonatomic, assign) SEL originalAction;
@property (nonatomic, assign) NSInteger originalTag;

- (void)setupEventMonitor;

@end


@implementation PGAlternateKeyButton

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEventMonitor];
    }
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupEventMonitor];

    self.originalTitle = self.title;
    self.originalTarget = self.target;
    self.originalAction = self.action;
    self.originalTag = self.tag;
}


- (void)setupEventMonitor
{
    if (self.eventMonitor) {
        return;
    }
    
    __weak PGAlternateKeyButton *blockSelf = self;
    self.eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSFlagsChangedMask handler:^(NSEvent *event) {
        blockSelf.usesAlternateKeyProperties = ([event modifierFlags] & NSAlternateKeyMask) != 0;
        return event;
    }];
}


- (void)dealloc
{
    if (self.eventMonitor) {
        [NSEvent removeMonitor:self.eventMonitor];
    }
}


- (void)setUsesAlternateKeyProperties:(BOOL)usesAlternateKeyProperties
{
    _usesAlternateKeyProperties = usesAlternateKeyProperties;

    if (_usesAlternateKeyProperties) {
        [super setTitle:self.alternateKeyTitle];
        [super setTarget:self.alternateKeyTarget];
        [super setAction:self.alternateKeyAction];
        [super setTag:self.alternateKeyTag];
    } else {
        [super setTitle:self.originalTitle];
        [super setTarget:self.originalTarget];
        [super setAction:self.originalAction];
        [super setTag:self.originalTag];
    }
}


- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.originalTitle = title;
}


- (void)setAction:(SEL)action
{
    [super setAction:action];
    self.originalAction = action;
}


- (void)setTarget:(id)target
{
    [super setTarget:target];
    self.originalTarget = target;
}


- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    self.originalTag = tag;
}

@end
