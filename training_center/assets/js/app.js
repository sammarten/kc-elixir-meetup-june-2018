import "phoenix_html"
import GymSocket from "./gym_socket"

export var GymChannel = {
  connect: function() {
    let trainingSessionContainer = document.getElementById("trainingSessionContainer")
    let name = trainingSessionContainer.dataset.name
    let role = trainingSessionContainer.dataset.role

    let gym = new GymSocket(name, role)
    gym.connect_to_gym()

    trainingSessionContainer.addEventListener("click", function(e) {
      console.log("Event Target", e)

      if(e.target && e.target.className == "exercise") {
        gym.complete_exercise(e.target.dataset.name)
      }
    })    
  }
}