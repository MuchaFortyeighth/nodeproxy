package com.mix.entity;


/**
 * Web接口响应对象
 *
 * @author ZH
 */
public class Result {
    /**
     * 响应码
     */
    private final Integer code;

    /**
     * 响应提示
     */
    private final String msg;

    /**
     * 响应数据
     */
    private final Object data;

    public Result(ResultCode resultCode){
        this.code = resultCode.getCode();
        this.msg = resultCode.getMessage();
        this.data = null;
    }

    public Result(ResultCode resultCode, Object data){
        this.code = resultCode.getCode();
        this.msg = resultCode.getMessage();
        this.data = data;
    }

    public Result(Integer code, String msg, Object data){
        this.code = code;
        this.msg = msg;
        this.data = data;
    }

    public static Result success(Object data){
        return new Result(ResultCode.SUCCESS,data);
    }



    public static Result success(){
        return new Result(ResultCode.SUCCESS,null);
    }

    public static Result failed(ResultCode resultCode,Object data){
        return new Result(resultCode,data);
    }

    public static Result failed(ResultCode resultCode){
        return new Result(resultCode,null);
    }

    public static Result failed(Object data){
        return new Result(ResultCode.SYSTEM_ERROR,data);
    }

    public static Result failed(){
        return new Result(ResultCode.SYSTEM_ERROR,null);
    }



    public Integer getCode() {
        return code;
    }

    public String getMsg() {
        return msg;
    }

    public Object getData() {
        return data;
    }
}
