//
//  CCScissorNode.h
//
// See http://www.cocos2d-iphone.org/forums/topic/simple-masked-sprite/ for history of this code
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

/** Restricts (clips) drawing of all children to a specific region. */
@interface CCScissorNode : CCNode


+(id) scissorNodeWithRect:(CGRect) rect;

@property (nonatomic) CGRect scissorRegion;

@end