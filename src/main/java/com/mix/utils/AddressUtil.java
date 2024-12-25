package com.mix.utils;

public class AddressUtil {
    public static String processAddress(String address) {
        if (address == null) {
            throw new IllegalArgumentException("Address cannot be null");
        }
        if (address.startsWith("0x") || address.startsWith("0X")) {
            return address.substring(2).toLowerCase(); // 移除前缀并转为小写
        }
        return address.toLowerCase(); // 转为小写
    }
}
