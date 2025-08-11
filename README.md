# RedM Gold Panning Script

A fully customizable gold panning script for RedM that allows players to search for gold nuggets in water bodies across the map.

## Features

- **Realistic Gold Panning**: Players can pan for gold in designated water locations
- **Configurable Settings**: Easily adjust gold finding chances, amounts, and values
- **Multiple Locations**: Pre-configured with several gold panning spots (easily expandable)
- **Visual Feedback**: Progress bar, notifications, and on-screen help text
- **Blip Markers**: Gold panning locations are marked on the map
- **Inventory Integration**: Supports VORP Inventory (needs to be configured)

## Installation

1. Copy the `vaultfx-goldpanning` folder to your RedM server's `resources` directory
2. Add `ensure vaultfx-goldpanning` to your `server.cfg` file
3. If using VORP Inventory, make sure to uncomment and configure the inventory-related sections in the code

## Configuration

All configuration options are in `config.lua`. Here's what you can customize:

- Gold finding chance and amounts
- Gold nugget value
- Panning duration
- Required item (set to `nil` if not needed)
- Gold panning locations
- Blip appearance
- Text strings

## Usage

1. Find a gold panning spot (marked with a gold pan icon on the map)
2. Stand in shallow water near the spot
3. Make sure you have a gold pan (if required in config)
4. Press `E` to start panning
5. Wait for the progress bar to complete
6. If successful, you'll find gold nuggets!

## Dependencies

- [VORP Core](https://github.com/VORPCORE/VORP-Core) (Required)
- [VORP Inventory](https://github.com/VORPCORE/VORP-Inventory) (Optional, for item support)

## Adding New Gold Panning Locations

To add new locations, edit the `Config.GoldPanning.locations` table in `config.lua`. Each location needs:

```lua
{x = x_coord, y = y_coord, z = z_coord, name = "Location Name"}
```

## Support

For support, please open an issue on the GitHub repository or contact the developer.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
