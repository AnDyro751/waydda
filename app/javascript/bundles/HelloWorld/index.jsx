import React, {useState} from 'react'

export default function HelloWorld() {
    const [demo, setDemo] = useState("HHEE")
    return (
        <button
            className={"cursor-pointer"}
            onClick={() => {
                console.log("HOLA ?")
                setDemo(`HOO A ${Math.random()}`)
            }}>Hola jeje 2222llolol {demo}</button>
    )
}