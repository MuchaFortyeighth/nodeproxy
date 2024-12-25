package com.mix.mapper;

import com.mix.entity.dto.Block;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface BlocksMapper {
    @Select("SELECT * FROM public.blocks " +
            "ORDER BY ABS(EXTRACT(EPOCH FROM timestamp - TO_TIMESTAMP(#{timestamp}, 'YYYY-MM-DD HH24:MI:SS'))) ASC " +
            "LIMIT 1")
    Block getNearestBlock(@Param("timestamp") String timestamp);
}

