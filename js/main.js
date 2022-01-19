const output = document.querySelector("#output"),
  task = document.querySelector("#task"),
  list = document.querySelector("#list");
document.addEventListener("DOMContentLoaded", () => {
  document.querySelector("#toDo").addEventListener("submit", (e) => {
    e.preventDefault();
    UI.showTask();
  });
});

class UI {
  constructor(taskName, done = true) {
    this.task = taskName;
    this.done = done;
  }
  static showTask() {
    const listItem = document.createElement("li");
    listItem.innerHTML = `<input type="checkbox">${task.value}`;
    list.appendChild(listItem);
    task.value = "";
  }
}
