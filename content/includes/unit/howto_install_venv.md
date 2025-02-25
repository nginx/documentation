.. include:: ../include/replace.rst
```

Create a virtual environment to install {{ app }}'s [app-pip-link]:

```console
   $ cd :nxt_ph:`/path/to/app/ <Path to the application directory; use a real path in your configuration>`
   $ :nxt_hint:`python3 --version <Make sure your virtual environment version matches the module version>`
         Python :nxt_hint:`3.Y.Z <Major version, minor version, and revision number>`
   $ python3 -m venv :nxt_hint:`venv <Arbitrary name of the virtual environment>`
   $ source :nxt_hint:`venv <Name of the virtual environment from the previous command>`/bin/activate
   $ pip install |app-pip-package|
   $ deactivate
```

{{< warning >}}
Create your virtual environment with a Python version that matches the
language module from Step 1 up to the minor number (**3.Y** in this
example). Also, the app **type** in Step 5 must {ref}`resolve
<configuration-apps-common>` to a similarly matching version; Unit doesn't
infer it from the environment.
{{< /warning >}}
