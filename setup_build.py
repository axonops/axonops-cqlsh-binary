from setuptools import setup, Extension, find_packages
from Cython.Build import cythonize
from Cython.Distutils import build_ext
import os, sys

# Find all Python files recursively
def find_python_files(directory):
    python_files = []
    for root, _, files in os.walk(directory):
        for file in files:
            if 'setup.py' in file or file == '__init__.py':
                continue
            if file.endswith('.py'):
                if "-" in file:
                    print(f"ERROR: You cannot cpythonize a file with '-' in its name: {file}")
                    sys.exit(1)
                path = os.path.join(root, file)
                module = path[:-3].replace(os.path.sep, '.')
                python_files.append(module)
    return python_files

cassandra_files = find_python_files('cassandra')
cqlshlib_files = find_python_files('cqlshlib')
wcwidth_files = find_python_files('wcwidth')

# Get Python static library path from environment
mac_link_args = []
mac_extra_objects = []
PYTHON_LIB_DIR = ''
BREWERY_HOME = os.getenv('BREWERY_HOME', '')
PYTHON_STATIC = os.getenv('PYTHON_STATIC_LIB', '')
if PYTHON_STATIC:
    PYTHON_LIB_DIR = os.path.dirname(PYTHON_STATIC)

    # macOS specific link arguments
    mac_link_args = [
        "-Wl,-all_load",  # Load all objects from static libraries
        "-Wl,-search_paths_first",  # Prioritize static libraries
        "-Wl,-dead_strip"  # Remove unused code
    ]
    mac_extra_objects = [
        PYTHON_STATIC,
        f"{BREWERY_HOME}/opt/gettext/lib/libintl.a",
    ]

# Define extensions for each Python file
ext_modules = []
for module in cqlshlib_files + cassandra_files + wcwidth_files:
    ext_modules.append(
        Extension(
            module, 
            [module.replace('.', os.path.sep) + '.py'],
            extra_objects=mac_extra_objects,
            extra_link_args=mac_link_args,
            library_dirs=[PYTHON_LIB_DIR],
        )
    )

# Add the main script
ext_modules.append(
    Extension(
        'cqlsh_main', 
        ['cqlsh.py'],
        extra_objects=mac_extra_objects,
        extra_link_args=mac_link_args,
        library_dirs=[PYTHON_LIB_DIR],
    )
)

setup(
    name="cqlsh",
    ext_modules=cythonize(ext_modules, compiler_directives={
        'language_level': 3,
        'embedsignature': True
    }),
    include_package_data=True,
    packages=find_packages(where='.'),
    cmdclass={'build_ext': build_ext},
    script_args=['build_ext'],
    py_modules=['cassandra', 'cqlshlib', 'wcwidth', 'encodings', 'platform'],
    # Additional metadata
    author="AxonOps Limited",
    author_email="support@axonops.com",
    description="cqlsh is a Python-based command-line client for running CQL commands on a cassandra cluster.",
    keywords=["cql", "cassandra", "cqlsh", "axonops"],
    url="https://github.com/axonops/axonops-cqlsh-binary",
)
