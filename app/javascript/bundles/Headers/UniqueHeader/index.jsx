import React from 'react';
import GetImageUrl from "../../../lib/getImageUrl";

export default function UniqueHeader() {
    return (
        <div className="flex w-full items-center justify-between py-3 px-16 bg-white border-b">
            <div className="w-3/12">
                <img
                    draggable="false"
                    src={GetImageUrl({publicId: "utils/w-logo-5.png", width: 100, height: 20})}
                    className="h-10"
                />
            </div>
            <div className="w-auto">
                <a href="/my-profile"
                   className="rounded-full"
                >
                    <img
                        className="h-8 shadow-lg rounded-full"
                        src={GetImageUrl({
                            publicId: "utils/icons8-test-account-96.png",
                            height: 50,
                            width: 50
                        })} alt="Waydda default profile photo"
                        title={"Mi perfil"}
                    />
                </a>
            </div>
        </div>
    )
}