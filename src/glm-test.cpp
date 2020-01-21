/*
 * This file is part of MXE. See LICENSE.md for licensing information.
 *
 * This file is a test program for glm, adapted from the code sample at
 * https://glm.g-truc.net/0.9.7/index.html.
 */

#define GLM_ENABLE_EXPERIMENTAL // for string_cast
#include <glm/gtc/matrix_transform.hpp> // glm::translate, glm::rotate, glm::scale, glm::perspective
#include <glm/mat4x4.hpp> // glm::mat4
#include <glm/vec3.hpp> // glm::vec3
#include <glm/vec4.hpp> // glm::vec4
#include <glm/gtx/string_cast.hpp> // so we can print a calculation result
#include <iostream>

glm::mat4 camera(float Translate, glm::vec2 const& Rotate)
{
    glm::mat4 Projection = glm::perspective(45.0f, 4.0f / 3.0f, 0.1f, 100.f);
    glm::mat4 View = glm::translate(glm::mat4(1.0f), glm::vec3(0.0f, 0.0f, -Translate));
    View = glm::rotate(View, Rotate.y, glm::vec3(-1.0f, 0.0f, 0.0f));
    View = glm::rotate(View, Rotate.x, glm::vec3(0.0f, 1.0f, 0.0f));
    glm::mat4 Model = glm::scale(glm::mat4(1.0f), glm::vec3(0.5f));
    return Projection * View * Model;
}

int main()
{
    glm::mat4 m = camera(0.0f, glm::vec2(0.0f, 0.0f));
    std::cout << glm::to_string(m) << std::endl;

    return 0;
}
