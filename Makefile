# Makefile for publishing timecopilot-uni2ts to PyPI

# Python version to test with
PYTHON_VERSION = 3.13

# Import statement to test
IMPORT_STATEMENT = from uni2ts.model.moirai import MoiraiForecast

clean:
	rm -rf uni2ts/
	rm -rf *.egg-info
	rm -rf dist/

create-dir:
	mkdir -p uni2ts
	cp -r src/uni2ts/* uni2ts/

# Build the wheel and sdist
build:
	uv build -n

# Test importing from built wheel
test-wheel:
	uv run --isolated --no-project -p $(PYTHON_VERSION) --with dist/*.whl -- python -c "$(IMPORT_STATEMENT)"

# Test importing from built sdist
test-sdist:
	uv run --isolated --no-project -p $(PYTHON_VERSION) --with dist/*.tar.gz -- python -c "$(IMPORT_STATEMENT)"

# Publish the package to PyPI using trusted publishing
publish:
	uv publish

# Test importing from the installed package after publishing
after-publish-test:
	uv run --isolated --no-project -p $(PYTHON_VERSION) --with timecopilot-uni2ts -- python -c "$(IMPORT_STATEMENT)"

# All steps
release: clean create-dir build test-wheel test-sdist publish after-publish-test

