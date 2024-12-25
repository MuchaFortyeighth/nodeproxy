package com.mix.service;

import com.mix.entity.dto.AddressFlowSummary;
import com.mix.entity.dto.RiskyAddressSummary;
import com.mix.mapper.AddressFlowMapper;
import com.mix.mapper.RiskyAddressMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AddressFlowService {

    @Autowired
    private AddressFlowMapper addressFlowMapper;

    public List<AddressFlowSummary> getOutflow(String address) {
        return addressFlowMapper.getOutflow(address);
    }

    public List<AddressFlowSummary> getInflow(String address) {
        return addressFlowMapper.getInflow(address);
    }

    @Autowired
    private RiskyAddressMapper riskyAddressMapper;

    public List<RiskyAddressSummary> getRiskyAddresses(String contractAddress) {
        return riskyAddressMapper.getRiskyAddresses(contractAddress);
    }

}
