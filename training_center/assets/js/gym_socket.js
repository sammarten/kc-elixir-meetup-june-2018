import {Socket, Presence} from "phoenix"

export default class GymSocket {
  constructor(name, role) {
    this.presences = {}
    this.socket = new Socket("/socket", {params: {name: name, role: role}})
    this.socket.connect()
  }

  connect_to_gym() {
    this.setup_channel()

    // This will only be sent to participants
    this.channel.on("participant_status", payload => {
      let trainingSessionContainer = document.getElementById("trainingSessionContainer")
      trainingSessionContainer.innerHTML = payload.html
    })

    // This will only be sent to trainers
    this.channel.on("status_updated", payload => {
      console.log("Received status updated message")
      let trainingSessionContainer = document.getElementById("trainingSessionContainer")
      trainingSessionContainer.innerHTML = payload.html      
    })

    this.channel.on("presence_state", state => {
      console.log("Presence state:", state)
      this.presences = Presence.syncState(this.presences, state)
    })

    this.channel.on("presence_diff", diff => {
      // console.table(presences["Sam"]["metas"])
      console.log("Presence diff:", diff)
      this.presences = Presence.syncDiff(this.presences, diff)
      console.log("Presences:", this.presences)
    })
  }

  setup_channel() {
    this.channel = this.socket.channel("training_session:1", {})
    this.channel
      .join()
      .receive("ok", resp => {
        console.log("connected: " + resp)
        // this.fetch_tally()
      })
      .receive("error", resp => {
        alert(resp)
        throw(resp)
      })
  }

  // This will only be called by participants
  complete_exercise(name) {
    this.channel.push("complete_exercise", {name: name})
  }
}