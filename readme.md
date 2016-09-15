# VerneMQ Dashboard Plugin

A web frontent dashboard for VerneMQ MQTT broker


# Installing 

You must have a recent version of Erlang installed (it's recommended to use the
same one VerneMQ is compiled for, typically > 17). To compile do:

    ./rebar3 compile

Then enable the plugin using:

    vmq-admin plugin enable --name vmq_dashboard --path <PathToYourPlugin>/vmq_dashboard/_build/default

Depending on how VerneMQ is started you might need ``sudo`` rights to access ``vmq-admin``.
Moreover the ``<PathToYourPlugin>`` should be accessible by VerneMQ (file permissions).

That's it!
