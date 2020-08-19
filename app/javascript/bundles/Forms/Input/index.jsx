import React from "react";

const Input = ({label, placeholder, type = "text", value, handleChange, name, handleBlur, children, handleFocus}) => (
    <div className="w-full flex mb-4 flex-wrap">
        <div className="w-full mb-2">
            <label className="text-xs text-gray-700">{label}</label>
        </div>
        <div className="w-full relative">
            <input type={type}
                   name={name}
                   onBlur={handleBlur ? handleBlur : null}
                   value={value}
                   onChange={handleChange}
                   placeholder={placeholder}
                   onFocus={handleFocus ? handleFocus : null}
                   className="w-full py-3 px-4 bg-main-gray focus:outline-none"/>
            {children}
        </div>
    </div>
)
export default Input