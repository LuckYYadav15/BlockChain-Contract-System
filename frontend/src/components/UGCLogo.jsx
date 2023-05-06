import React from "react";
import logo from "../assets/UGC_LOGO.png";
import {Link} from 'react-router-dom'

function UGCLogo() {
  return (
    <div className="flex items-center">
      {/* <Link to="/" className="pr-2">
        <img src={logo} alt="UGC LOGO" className="w-16 h-16" />
      </Link> */}
      <div className="flex flex-col">
        <p className="text-gray-700 font-medium">
          Contract System
        </p>
        <p className="text-gray-500 text-xs">Every Bid Matters </p>
      </div>
    </div>
  );
}

export default UGCLogo;
