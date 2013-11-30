NODE_VERSION=$(shell ./latest_node_version.pl )
NODE_VERSION_NAME=node-$(NODE_VERSION)
NODE_URL=http://nodejs.org/dist/$(NODE_VERSION)/
NODE_VERSION_URL=$(NODE_URL)$(NODE_VERSION_NAME).tar.gz

.PHONY: install_latest

#download_latest:
#	$(MAKE) $(NODE_VERSION)/

install_latest: $(NODE_VERSION_NAME)/
	cd $(NODE_VERSION_NAME) && ./configure --prefix=/opt/$(NODE_VERSION_NAME)
	$(MAKE) -C $(NODE_VERSION_NAME)
	sudo $(MAKE) -C $(NODE_VERSION_NAME) install

$(NODE_VERSION_NAME)/: $(NODE_VERSION_NAME).tar.gz
	tar -axvf $(NODE_VERSION_NAME).tar.gz
	
$(NODE_VERSION_NAME).tar.gz:
	wget $(NODE_VERSION_URL)
