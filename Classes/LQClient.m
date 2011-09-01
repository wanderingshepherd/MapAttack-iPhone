//
//  LQClient.m
//  MapAttack
//
//  Created by Aaron Parecki on 2011-08-31.
//  Copyright 2011 Geoloqi.com. All rights reserved.
//

#import "LQClient.h"
#import "LQConfig.h"
#import "CJSONDeserializer.h"

static LQClient *singleton = nil;

@implementation LQClient

@synthesize accessToken;

+ (LQClient *)single {
    if(!singleton) {
		singleton = [[self alloc] init];
	}
	return singleton;
}

- (ASIHTTPRequest *)appRequestWithURL:(NSURL *)url {
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
	[request setUsername:LQ_OAUTH_CLIENT_ID];
	[request setPassword:LQ_OAUTH_SECRET];
	return request;
}

- (ASIHTTPRequest *)userRequestWithURL:(NSURL *)url {
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"OAuth %@"]];
	return request;
}

- (NSDictionary *)dictionaryFromResponse:(NSString *)response {
	NSError *err = nil;
	NSDictionary *res = [[CJSONDeserializer deserializer] deserializeAsDictionary:[response dataUsingEncoding:NSUTF8StringEncoding]
																			error:&err];
	return res;
}

#pragma mark public methods

- (BOOL)isLoggedIn {
	return [[NSUserDefaults standardUserDefaults] stringForKey:LQRefreshTokenKey] != nil;	
}

- (void)sendPushToken:(NSString *)token {
	// TODO: Send this device token to the Geoloqi API
}

- (void)createNewAccountWithEmail:(NSString *)email initials:(NSString *)initials callback:(LQHTTPRequestCallback)callback {
	NSURL *url = [NSURL URLWithString:@"https://api.geoloqi.com/1/account/create_anon"];
	__block ASIHTTPRequest *request = [self appRequestWithURL:url];
	[request setCompletionBlock:^{
		callback(nil, [self dictionaryFromResponse:[request responseString]]);
	}];
	[request startAsynchronous];
}

- (void)getNearbyLayers:(LQHTTPRequestCallback)callback {
	NSURL *url = [NSURL URLWithString:@"https://api.geoloqi.com/1/layer/nearby?latitude=45.5246&longitude=-122.6843"];
	__block ASIHTTPRequest *request = [self userRequestWithURL:url];
	[request setCompletionBlock:^{
		callback(nil, [self dictionaryFromResponse:[request responseString]]);
	}];
	[request startAsynchronous];
}

- (void)dealloc {
	[accessToken release];
	[super dealloc];
}

@end
