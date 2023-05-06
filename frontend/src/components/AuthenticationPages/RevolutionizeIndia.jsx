import React from 'react'
import loginFrame from "../../assets/Authentication/blockchain.jpg"

function RevolutionizeIndia() {
  return (
    <div className='w-6/12 orangeGradient h-screen'>
      <img src={loginFrame} alt="login frame" className='h-screen' />
      <div className="text-center relative top-[-25%]">
        <h4 className='text-xl font-semibold text-white'>Let's Revolutionize Indian Contract System</h4>
        <h6 className='text-sm text-white'>A platform for publishing and bidding Contracts</h6>
      </div>
    </div>
  )
}

export default RevolutionizeIndia