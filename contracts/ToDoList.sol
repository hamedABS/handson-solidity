// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ToDoList {
    struct Task {
        string item;
        bool isCompleted;
        bool deleted;
    }

    mapping(address=> Task[]) private tasks;
    address public owner;

    modifier onlyOwner{
        require(msg.sender == owner, "Only Owner can call this function."); 
        _;
    }

    event TaskCreated(address indexed user, uint index, string text);
    event TaskUpdated(address indexed user, uint index, string newText);
    event TaskToggled(address indexed user, uint index, bool newStatus);
    event TaskDeleted(address indexed user, uint index);

    function addItem(string memory _itemTitle) external  {
        tasks[msg.sender].push(Task(_itemTitle, false, false));
        emit TaskCreated(msg.sender,tasks[msg.sender].length -1 , _itemTitle);
    }

    function toggleComplete(uint _index) external{
        checkIndex(_index);
        Task storage task = tasks[msg.sender][_index];
        require(!task.deleted, "Task is deleted"); 
        task.isCompleted = !task.isCompleted;
        emit TaskToggled(msg.sender , _index, task.isCompleted );   
    }

    function changeTaskTitle(uint _index, string memory newTitle) external {
        checkIndex(_index);
        Task storage task = tasks[msg.sender][_index];
        require(!task.deleted,"This task is already deleted."); 
        task.item = newTitle;
        emit TaskUpdated(msg.sender, _index ,task.item );
    }

    function checkIndex(uint _index) private view {
        require(_index<tasks[msg.sender].length, "Invalid index");
    }

    function getUserTaskCount() external view returns(uint){
        return tasks[msg.sender].length;
    }

    function getUserTasks() external view returns (Task[] memory){
        return tasks[msg.sender];
    }

    function deleteUserAllTasks() external onlyOwner{
        delete tasks[msg.sender];
        emit TaskDeleted(msg.sender , tasks[msg.sender].length -1);
    }

    function removeItem(uint _index) external {
        checkIndex(_index);
        delete tasks[msg.sender][_index];
        emit TaskDeleted(msg.sender, _index);
    }

    function getItemByIndex(uint _index) external view returns (Task memory) {
        checkIndex(_index);
        return tasks[msg.sender][_index];
    }
}