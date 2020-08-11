const getDefaultHeaders = () => {
    const token =
        document.querySelector('[name=csrf-token]').content
    return {
        'X-CSRF-TOKEN': token,
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    }
}

export default getDefaultHeaders