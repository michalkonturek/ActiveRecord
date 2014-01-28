//
//  MKMacro+Debug.h
//  MKCoreData
//
//  Created by Michal Konturek on 01/06/2011.
//  Copyright (c) 2011 Michal Konturek. All rights reserved.
//

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#ifdef DEBUG
#   define MLog(fmt, ...) NSLog((@"%@ [Line %d] " fmt), NSStringFromClass([self class]), __LINE__, ##__VA_ARGS__);
#else
#   define MLog(...)
#endif
