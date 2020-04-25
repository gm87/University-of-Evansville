import React from 'react'

import GoogleMapReact from 'google-map-react'

class GoogleMap extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            zoom: props.zoom || 11
        }
    }

    handleApiLoaded = (map, maps) => {
        new maps.Marker({
            position: {lat: this.props.centerLat, lng: this.props.centerLng},
            map: map,
        })
    }

    render() {
        return (
            <div style={{height: '20vh', width: '30%'}}>
                <GoogleMapReact
                    bootstrapURLKeys={{ key: process.env.REACT_APP_MAPS_API_KEY }}
                    defaultCenter={{lat: this.props.centerLat, lng: this.props.centerLng}}
                    defaultZoom={this.state.zoom}
                    yesIWantToUseGoogleMapApiInternals
                    onGoogleApiLoaded={({ map, maps }) => this.handleApiLoaded(map, maps)}
                >
                </GoogleMapReact>
            </div>
        )
    }
}

export default GoogleMap