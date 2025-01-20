package com.mix.controller;

import com.mix.entity.Result;
import com.mix.entity.dto.AddressFlowSummary;
import com.mix.service.AddressFlowService;
import com.mix.utils.AddressUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/address")
public class AddressController {

    @Autowired
    private AddressFlowService addressFlowService;


    @GetMapping("/riskList/{contractAddress}")
    public Result getRiskAddressList(@PathVariable String contractAddress) {
        contractAddress = AddressUtil.processAddress(contractAddress);
        return Result.success(addressFlowService.getRiskyAddresses(contractAddress));
    }

    @GetMapping("/riskList/{contractAddress}/{addressPattern}")
    public Result getRiskAddressListWithPattern(
            @PathVariable String contractAddress,
            @PathVariable String addressPattern) {
        contractAddress = AddressUtil.processAddress(contractAddress);
        return Result.success(addressFlowService.getRiskyAddresses(contractAddress, addressPattern));
    }

    @GetMapping("/transFlow/{address}")
    public Result getAddressFlow(@PathVariable String address) {
        address = AddressUtil.processAddress(address);
        List<AddressFlowSummary> outflow = addressFlowService.getOutflow(address);
        List<AddressFlowSummary> inflow = addressFlowService.getInflow(address);

        Map<String, List<AddressFlowSummary>> result = new HashMap<>();
        result.put("outflow", outflow);
        result.put("inflow", inflow);
        return Result.success(result);
    }

}
