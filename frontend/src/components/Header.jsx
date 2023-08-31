import { React } from 'react'
import { Nav, Navbar } from 'react-bootstrap'
import { Link } from 'react-router-dom'

export const Header = ({ user, setUser }) => {
  const logout = () => {
    window.localStorage.removeItem('user')
    setUser()
  }
  return (
    <Navbar collapseOnSelect expand="sm">
      <span className="navbar-brand bg-light rounded-pill p-1" id='cabinet'>{ user?.role } cabinet</span>
      <Navbar.Toggle />
      <Navbar.Collapse className='justify-content-end'>
        <Nav className="navbar-light">
          <ul className="navbar-nav mr-auto">
            <li className="nav-item m-2">
              <Nav.Item>
                <Nav.Link as={ Link } to="/">
                  Home
                </Nav.Link>
              </Nav.Item>
            </li>
            {user?.role === 'admin' && (
              <li className="nav-item m-2">
                <Nav.Item>
                  <Nav.Link as={ Link } to='merchant/index' state={{ user }}>
                    Merchants
                  </Nav.Link>
                </Nav.Item>
              </li>
            )}

            {user?.role === 'merchant' && (
              <li className="nav-item m-2">
                <Nav.Item>
                  <Nav.Link as={ Link } to='transaction/index' state={{ user }}>
                    Transactions
                  </Nav.Link>
                </Nav.Item>
              </li>
            )}

            <li className="nav-item m-2">
              <Nav.Item>
                <button className='nav-link' onClick={ logout } >Log out</button>
              </Nav.Item>
            </li>
          </ul>
        </Nav>
      </Navbar.Collapse>
    </Navbar>
  )
}
