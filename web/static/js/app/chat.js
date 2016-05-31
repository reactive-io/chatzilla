import React from "react";
import ReactDom from "react-dom";

import socket from "web/static/js/socket";

export default class Chat extends React.Component {
  constructor(props) {
    super(props);

    let channel = socket.channel(this.props.topic, {test: true});
    channel.join();

    channel.on("message:new", (message) => {
      this.addMessageToList(message);
    });

    channel.on("user:join", (user) => {
      this.addUserToList(user);
    });

    channel.on("user:leave", (user) => {
      this.removeUserFromList(user);
    });

    this.state = {
      channel: channel,
      message: "",
      messageList: [],
      userList: []
    };
  }

  componentDidMount() {
    this.refs.messageField.focus();
  }

  render() {
    return (
      <div>
        <div className="row">
          <div className="col-xs-12">
            <div>{this.props.topic}</div>

            <form onSubmit={this.handleSubmit.bind(this)}>
              <input type="text" ref="messageField" onChange={this.handleOnChange.bind(this)} value={this.state.message} />
              <input type="submit" value="Send" />
            </form>
          </div>
        </div>

        <div className="row">
          <div className="col-xs-6">
            <b>Chats:</b>

            <ul>
              {this.state.messageList.map(function (item, index) {
                return <li key={index}><strong>{item.name}</strong>: <span>{item.body}</span></li>;
              })}
            </ul>
          </div>

          <div className="col-xs-6">
            <b>Users:</b>

            <ul>
              {this.state.userList.map(function (user, index) {
                return <li key={index}><strong>{user}</strong></li>;
              })}
            </ul>
          </div>
        </div>
      </div>
    );
  }

  handleOnChange(e) {
    this.setState({message: e.target.value});
  }

  handleSubmit(e) {
    e.preventDefault();

    this.state.channel.push("message:submit", {body: this.state.message});

    this.setState({message: ""});
  }

  addMessageToList(newMessage) {
    this.setState({messageList: this.state.messageList.concat([newMessage])});
  }

  addUserToList(newUsers) {
    this.addMessageToList({name: newUsers.user, body: "Has joined the chat!"});

    this.setState({userList: newUsers.user_list});
  }

  removeUserFromList(oldUsers) {
    this.addMessageToList({name: oldUsers.user, body: "Has left the chat!"});

    this.setState({userList: oldUsers.user_list});
  }
}
