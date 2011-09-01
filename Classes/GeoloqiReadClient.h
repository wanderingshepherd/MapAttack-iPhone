//
//  GeoloqiReadClient.h
//  MapAttack
//
//  Created by Aaron Parecki on 2011-08-21.
//  Copyright 2011 Geoloqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

@interface GeoloqiReadClient : NSObject {
	AsyncSocket *asyncSocket;

}

- (void)normalConnect;
- (void)disconnect;

@end
