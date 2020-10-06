pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

interface IMpoint {
    function delegate(address delegate_) external;
    function balanceOf(address account) external view returns (uint);
    function transfer(address dst, uint rawAmount) external returns (bool);
    function transferFrom(address src, address dst, uint rawAmount) external returns (bool);
}

interface IGovernorAlpha {
    function propose(
        address[] memory targets,
        uint[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    ) external returns (uint);

    function castVote(uint proposalId, bool support) external;
}
