import React, {useState} from 'react'

export default function HelloWorldTwo() {
    const [demo, setDemo] = useState("HHEE")
    return (
        <button
            className={"cursor-pointer"}
            onClick={() => {
                console.log("HOLA ?")
                setDemo(`HOO A ${Math.random()}`)
            }}>DOOOOOSSS {demo}</button>
    )
}