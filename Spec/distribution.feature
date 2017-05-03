Feature: We need distribute our module to the public
    It should be published someplace that is easy to find

    Scenario: A user needs to be able to find our module in the PSGallery
        Given We have functions to publish
            And We have a module
        When The user searches for our module
        Then They can install the module