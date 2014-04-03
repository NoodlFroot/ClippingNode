//
//  CCScissorNode.m
//
// See http://www.cocos2d-iphone.org/forums/topic/simple-masked-sprite/ for history of this code
//

#import "CCScissorNode.h"


@implementation CCScissorNode
{
    CGRect scissorRegionInPoints;
    CGRect scissorRegion;
}

+(id) scissorNodeWithRect:(CGRect) rect
{
    return [[self alloc] initWithRect:rect];
}

-(id) initWithRect:(CGRect) rect
{
    if ( (self = [super init]) )
	{
        [self setScissorRegion:rect];
    }
    return self;
}

-(void) deviceOrientationChanged:(NSNotification*)notification
{
	// re-adjust the clipping region according to the current orientation
	[self setScissorRegion:scissorRegionInPoints];
}

-(CGRect) scissorRegion
{
    return scissorRegionInPoints;
}

-(void) setScissorRegion:(CGRect)region
{
    // keep the original region coordinates in case the user wants them back unchanged and so we can recalculate on a scale change
	scissorRegionInPoints = region;
	
	//CGPoint origin = [self convertPositionToPoints:region.origin type:self.positionType];
//	CGSize size = [self convertContentSizeToPoints:region.size type:self.contentSizeType];
//	self.contentSize = size;
    
    // respect scaling
    scissorRegion = CGRectMake(region.origin.x * _scaleX, region.origin.y * _scaleY,
                                region.size.width * _scaleX, region.size.height * _scaleY);
}

-(void) setScale:(float)newScale
{
    [super setScale:newScale];
	
    [self setScissorRegion:scissorRegionInPoints];
}

// TODO: Can we just use the content size of the node as the clipping area? Makes more sense to me than defining a new rect????
// Except we can't use position to define the origin as then all child nodes are offset......
//- (void)setContentSize:(CGSize)contentSize
//{
//	[super setContentSize:contentSize];
//	
//	
//}

-(void) visit
{
    glEnable(GL_SCISSOR_TEST);

    CGPoint worldPosition = [self convertToWorldSpace:CGPointZero];
    const CGFloat s = [[CCDirector sharedDirector] contentScaleFactor];
	
    glScissor(scissorRegion.origin.x + (worldPosition.x * s),
              scissorRegion.origin.y + (worldPosition.y * s),
              scissorRegion.size.width,
              scissorRegion.size.height);
    
    [super visit];
    
    glDisable(GL_SCISSOR_TEST);
}

@end

