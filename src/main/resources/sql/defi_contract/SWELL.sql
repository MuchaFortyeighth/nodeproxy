INSERT INTO defi_contracts
(contract_name, contract_address, primary_category, secondary_category,
	source_code,
	source_code_tree,
	source_code_scan_result)
VALUES('SWELL', '0x0a6e7ba5042b38349e437ec6db6214aec7b35676', '金融功能类', '流动性质押',
$$
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// SWELL ERC20 contract
contract SwellToken is ERC20 {
    constructor(address _receiver, uint256 _totalSupply) ERC20("Swell Governance Token", "SWELL") {
        _mint(_receiver, _totalSupply);
    }
}
$$,
$$

$$,
''
);