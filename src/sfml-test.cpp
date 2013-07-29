/*
 * This file is part of MXE.
 * See index.html for further information.
 */

#include <SFML/Audio.hpp>
#include <SFML/Network.hpp>
#include <SFML/Graphics.hpp>

using namespace sf;

int main()
{
    // Create the main window
    RenderWindow window(VideoMode(800, 600), "SFML window");

    Music music;
    Texture texture;
    Font font;
    Text text;
    TcpSocket socket;

    CircleShape shape(200);
    shape.setPosition(200, 100);
    shape.setFillColor(Color::Red);

    while (window.isOpen())
    {
        // Process events
        Event event;
        while (window.pollEvent(event))
        {
            // Close window : exit
            if (event.type == Event::Closed)
                window.close();
        }
        // Clear screen
        window.clear();
        // Draw the sprite
        window.draw(shape);
        // Update the window
        window.display();
    }

    return 0;
}
