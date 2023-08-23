package com.mix.service;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * Created by reeves on 2023/8/22.
 */
public class ChannelCounter {

    public static AtomicInteger serverReadTimes = new AtomicInteger();
    public static AtomicInteger clientReadTimes = new AtomicInteger();
}
