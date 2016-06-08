//
//  YMDCDataProvider.m
//  AppDevKit
//
//  Created by Jeff Lin on 3/19/16.
//  Copyright © 2016, Yahoo Inc.
//  Licensed under the terms of the BSD License.
//  Please see the LICENSE file in the project root for terms.
//

#import "YMDCDataProvider.h"

@implementation YMDCDataProvider

+ (NSArray *)titles{
    return @[@"erectus",
             @"David",
             @"Colleen",
             @"Omus",
             @"Buck"];
}

+ (NSArray *)itemDescription{
    return @[
             @"Why are the Cats bad?",
             @"Why is it that in the majority of movies involving cats they are always evil/sinister; they're always the bad guy?",
             @"Also you have from a long time ago, The Cat from Outer Space, or later Oscar and Company (both cats and dogs were both sides). It does seem that mainstream nowadays will go with the felines being uppity and dogs fun loving. Though even in Oscar & Company, Oscar was a kitten. I guess it depends on the writer/director/producer.",
             @"Or, controlling types prefer cats because they relate to them better.",
             @"Are they getting rid of the opening text?"
             ];
}

+ (NSString *)movieDescription
{
    return @"There's a secret war being waged in the homes and neighborhoods of Earth that the humans don't even know about; an eternal struggle between two great armies: the Cats and the Dogs. The film follows a Cat's plan to destroy a new vaccine, that if developed, would destroy all human allergies to Dogs, and the Dogs' efforts to stop the Cats. Specifically, it's the story of a young pup whose job it is to guard the vaccine. Other dogs include a wise older dog who watches out for him, a large friendly dog, and a small dog who serves as an electronics expert. Jeff Goldblum is the human scientist that invented the vaccine.";
}

@end
