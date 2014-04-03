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

-(CGRect) scissorRegion
{
    return scissorRegionInPoints;
}

-(void) setScissorRegion:(CGRect)region
{
    // keep the original region coordinates in case the user wants them back unchanged and so we can recalculate on a scale change
	scissorRegionInPoints = region;
	
	// TODO: Make the passed in region work in the various postion/content size coordinate systems supported in v3
	
//	CGPoint origin = [self convertPositionToPoints:region.origin type:self.positionType];
//	CGSize size = [self convertContentSizeToPoints:region.size type:self.contentSizeType];
//	self.contentSize = size;
    
    // respect scaling
    scissorRegion = CGRectMake(region.origin.x * _scaleX, region.origin.y * _scaleY,
							   region.size.width * _scaleX, region.size.height * _scaleY);
}

// TODO: Work out what it means for the position of this node to change

// Handle changes in scale
-(void) setScale:(float)newScale
{
    [super setScale:newScale];
	
    [self setScissorRegion:scissorRegionInPoints];
}

-(void) setScaleX:(float)scaleX
{
    [super setScaleX:scaleX];
	
    [self setScissorRegion:scissorRegionInPoints];
}

-(void) setScaleY:(float)scaleY
{
    [super setScaleY:scaleY];
	
    [self setScissorRegion:scissorRegionInPoints];
}

-(void) visit
{
	// TODO: Remember the current scissor state and region so we can nest clipping nodes?
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

