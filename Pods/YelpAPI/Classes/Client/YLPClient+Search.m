//
//  YLPClient+Search.m
//  Pods
//
//  Created by David Chen on 1/22/16.
//
//

#import "YLPSearch.h"
#import "YLPClient+Search.h"
#import "YLPCoordinate.h"
#import "YLPQuery.h"
#import "YLPQueryPrivate.h"
#import "YLPResponsePrivate.h"
#import "YLPClientPrivate.h"

@implementation YLPClient (Search)

- (void)searchWithLocation:(NSString *)location
         completionHandler:(YLPSearchCompletionHandler)completionHandler {
    YLPQuery *query = [[YLPQuery alloc] initWithLocation:location];
    [self searchWithQuery:query completionHandler:completionHandler];
}

- (void)searchWithLocation:(NSString *)location
                      term:(NSString *)term
                     limit:(NSUInteger)limit
                    offset:(NSUInteger)offset
                      sort:(YLPSortType)sort
         completionHandler:(YLPSearchCompletionHandler)completionHandler {
    YLPQuery *query = [[YLPQuery alloc] initWithLocation:location];
    query.term = term;
    query.limit = limit;
    query.offset = offset;
    query.sort = sort;
    [self searchWithQuery:query completionHandler:completionHandler];
}

- (void)searchWithCoordinate:(YLPCoordinate *)coordinate
                        term:(NSString *)term limit:(NSUInteger)limit
                      offset:(NSUInteger)offset
                        sort:(YLPSortType)sort
           completionHandler:(YLPSearchCompletionHandler)completionHandler {
    YLPQuery *query = [[YLPQuery alloc] initWithCoordinate:coordinate];
    query.term = term;
    query.limit = limit;
    query.offset = offset;
    query.sort = sort;
    [self searchWithQuery:query completionHandler:completionHandler];
}

- (void)searchWithCoordinate:(YLPCoordinate *)coordinate
           completionHandler:(YLPSearchCompletionHandler)completionHandler {
    YLPQuery *query = [[YLPQuery alloc] initWithCoordinate:coordinate];
    [self searchWithQuery:query completionHandler:completionHandler];
}

- (NSURLRequest *)searchRequestWithParams:(NSDictionary *)params {
    return [self requestWithPath:@"/v3/businesses/search" params:params];
}

- (void)searchWithQuery:(YLPQuery *)query
      completionHandler:(YLPSearchCompletionHandler)completionHandler {    
    NSDictionary *mockResponse = @{
        @"total": @10,
        @"businesses": @[
            @{
                @"id": @"coffee-1",
                @"name": @"Philz Coffee",
                @"is_closed": @NO,
                @"image_url": @"https://example.com/philz.jpg",
                @"url": @"https://www.yelp.com/biz/philz-coffee-cupertino",
                @"rating": @4.5,
                @"review_count": @1240,
                @"phone": @"+14089990001",
                @"categories": @[
                    @{ @"alias": @"coffee", @"title": @"Coffee & Tea" }
                ],
                @"coordinates": @{
                    @"latitude": @37.3403,
                    @"longitude": @-122.0322
                },
                @"location": @{
                    @"city": @"Cupertino",
                    @"state": @"CA",
                    @"zip_code": @"95014",
                    @"country": @"US",
                    @"display_address": @[
                        @"20686 Stevens Creek Blvd",
                        @"Cupertino, CA 95014"
                    ]
                }
            },
            @{
                @"id": @"coffee-2",
                @"name": @"Blue Bottle Coffee",
                @"is_closed": @NO,
                @"image_url": @"https://example.com/bluebottle.jpg",
                @"url": @"https://www.yelp.com/biz/blue-bottle-coffee-cupertino",
                @"rating": @4.0,
                @"review_count": @820,
                @"phone": @"+14089990002",
                @"categories": @[
                    @{ @"alias": @"coffee", @"title": @"Coffee & Tea" }
                ],
                @"coordinates": @{
                    @"latitude": @37.3318,
                    @"longitude": @-122.02954
                },
                @"location": @{
                    @"city": @"Cupertino",
                    @"state": @"CA",
                    @"zip_code": @"95014",
                    @"country": @"US",
                    @"display_address": @[
                        @"19501 Biscayne Dr",
                        @"Cupertino, CA 95014"
                    ]
                }
            },
            @{
                @"id": @"coffee-3",
                @"name": @"Voyager Craft Coffee",
                @"is_closed": @NO,
                @"image_url": @"https://example.com/voyager.jpg",
                @"url": @"https://www.yelp.com/biz/voyager-craft-coffee",
                @"rating": @4.5,
                @"review_count": @510,
                @"phone": @"+14089990003",
                @"categories": @[
                    @{ @"alias": @"coffee", @"title": @"Coffee & Tea" }
                ],
                @"coordinates": @{
                    @"latitude": @37.329,
                    @"longitude": @-122.0293
                },
                @"location": @{
                    @"city": @"Santa Clara",
                    @"state": @"CA",
                    @"zip_code": @"95051",
                    @"country": @"US",
                    @"display_address": @[
                        @"3985 Stevens Creek Blvd",
                        @"Santa Clara, CA 95051"
                    ]
                }
            },
            @{
                @"id": @"coffee-4",
                @"name": @"Coffee Society",
                @"is_closed": @NO,
                @"image_url": @"https://example.com/society.jpg",
                @"url": @"https://www.yelp.com/biz/coffee-society-cupertino",
                @"rating": @4.0,
                @"review_count": @340,
                @"phone": @"+14089990004",
                @"categories": @[
                    @{ @"alias": @"coffee", @"title": @"Coffee & Tea" }
                ],
                @"coordinates": @{
                    @"latitude": @37.339,
                    @"longitude": @-122.0259
                },
                @"location": @{
                    @"city": @"Cupertino",
                    @"state": @"CA",
                    @"zip_code": @"95014",
                    @"country": @"US",
                    @"display_address": @[
                        @"21265 Stevens Creek Blvd",
                        @"Cupertino, CA 95014"
                    ]
                }
            },
            @{
                @"id": @"coffee-5",
                @"name": @"Starbucks",
                @"is_closed": @NO,
                @"image_url": @"https://example.com/starbucks.jpg",
                @"url": @"https://www.yelp.com/biz/starbucks-cupertino",
                @"rating": @3.5,
                @"review_count": @215,
                @"phone": @"+14089990005",
                @"categories": @[
                    @{ @"alias": @"coffee", @"title": @"Coffee & Tea" }
                ],
                @"coordinates": @{
                    @"latitude": @37.3245,
                    @"longitude": @-122.0348
                },
                @"location": @{
                    @"city": @"Cupertino",
                    @"state": @"CA",
                    @"zip_code": @"95014",
                    @"country": @"US",
                    @"display_address": @[
                        @"1 Apple Park Way",
                        @"Cupertino, CA 95014"
                    ]
                }
            }
        ],
        @"region": @{
            @"center": @{
                @"latitude": @37.3349,
                @"longitude": @-122.0090
            }
        }
    };

    YLPSearch *search = [[YLPSearch alloc] initWithDictionary:mockResponse];
    completionHandler(search, nil);
}

@end
