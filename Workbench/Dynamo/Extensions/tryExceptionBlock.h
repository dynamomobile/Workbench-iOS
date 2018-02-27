#ifndef tryExceptionBlock_h
#define tryExceptionBlock_h

NS_INLINE
NSException *tryExceptionBlock(void(^block)(void)) {
    @try {
        block();
    }
    @catch (NSException *exception) {
        return exception;
    }
    return nil;
}

#endif
