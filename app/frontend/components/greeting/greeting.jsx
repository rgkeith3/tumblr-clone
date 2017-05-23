import React from 'react'
import { Link, withRouter } from 'react-router-dom'

class Greeting extends React.Component {
  constructor(props) {
    super(props)
    this.logout = this.logout.bind(this)
  }

  logout(e) {
    e.preventDefault()
    this.props.logout()
    this.props.history.push('/')
  }

  render() {
    if (this.props.currentUser) {
      return (
        <section className="greeting">
          <Link to='/explore'>
            <i className='fa fa-globe fa-lg'></i>
          </Link>
          <Link to='/dashboard'>
            <h1>{this.props.currentUser.username}</h1>
          </Link>
          <button onClick={this.logout}>Logout</button>
        </section>
      )
    } else {
      let link
      if (this.props.pathname === '/login') {
        link = (<Link to='/signup'>
                  Sign Up
                </Link>)
      } else if (this.props.pathname === '/signup') {
        link = (<Link to='/login'>
                  Login
                </Link>)
      } else {
        link = (<div>
                  <Link to='/signup'>
                    Sign Up
                  </Link>
                  <Link to='/login'>
                    Login
                  </Link>
                </div>)
      }
      return (
        <section className="greeting">
          {link}
        </section>
      )
    }
  }
}

export default withRouter(Greeting)
