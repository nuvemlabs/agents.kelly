# Makefile for agents.kelly
# Google ADK Agent with Streaming Audio & Real-time Chat

# Configuration
UVICORN_PORT ?= 8000
ADK_PORT ?= 8080
UVICORN_URL = http://127.0.0.1:$(UVICORN_PORT)
ADK_URL = http://localhost:$(ADK_PORT)

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
RED = \033[0;31m
NC = \033[0m # No Color

# Default target
.DEFAULT_GOAL := help

# Detect operating system for browser command
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    BROWSER_CMD = open
else ifeq ($(UNAME_S),Linux)
    BROWSER_CMD = xdg-open
else
    BROWSER_CMD = start
endif

.PHONY: help install run-uvicorn run-adk dev-uvicorn dev-adk open-uvicorn open-adk clean status check deps stop

help: ## Show this help message
	@echo "$(BLUE)agents.kelly - Google ADK Agent with Streaming$(NC)"
	@echo ""
	@echo "$(GREEN)🚀 Quick Start (Recommended):$(NC)"
	@echo "  $(YELLOW)make install$(NC)      - Install dependencies"
	@echo "  $(YELLOW)make run-uvicorn$(NC)   - Run with uvicorn server"
	@echo "  $(YELLOW)make dev-uvicorn$(NC)   - Run uvicorn + open browser"
	@echo ""
	@echo "$(GREEN)📋 Available commands:$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(GREEN)⚙️  Configuration:$(NC)"
	@echo "  Uvicorn Port: $(UVICORN_PORT) (override with UVICORN_PORT=xxxx)"
	@echo "  Uvicorn URL:  $(UVICORN_URL)"
	@echo "  ADK Port:     $(ADK_PORT) (override with ADK_PORT=xxxx)"
	@echo "  ADK URL:      $(ADK_URL)"

install: ## Install Google ADK and verify dependencies
	@echo "$(GREEN)Installing Google ADK dependencies...$(NC)"
	@pip show google-adk > /dev/null 2>&1 || pip install google-adk
	@echo "$(GREEN)✅ Google ADK installed$(NC)"
	@echo ""
	@echo "$(GREEN)📋 Dependency Status:$(NC)"
	@pip show google-adk | grep Version || echo "$(RED)✗ google-adk not found$(NC)"
	@which uvicorn > /dev/null 2>&1 && echo "$(GREEN)✓ uvicorn available$(NC)" || echo "$(RED)✗ uvicorn not found$(NC)"
	@which adk > /dev/null 2>&1 && echo "$(GREEN)✓ adk available$(NC)" || echo "$(YELLOW)⚠ adk not found (optional)$(NC)"
	@echo ""
	@echo "$(GREEN)🔧 Environment Check:$(NC)"
	@test -f app/.env && echo "$(GREEN)✓ app/.env exists$(NC)" || echo "$(YELLOW)⚠ app/.env missing - create with GOOGLE_API_KEY$(NC)"

run-uvicorn: ## Run with uvicorn server (recommended)
	@echo "$(GREEN)🚀 Starting uvicorn server...$(NC)"
	@echo "$(BLUE)📍 Access at: $(UVICORN_URL)$(NC)"
	@echo "$(YELLOW)💡 Press Ctrl+C to stop$(NC)"
	@echo ""
	cd app && uvicorn main:app --reload --host 127.0.0.1 --port $(UVICORN_PORT)

run-adk: ## Run with ADK web interface (if adk installed)
	@echo "$(GREEN)🚀 Starting ADK web interface...$(NC)"
	@echo "$(BLUE)📍 Access at: $(ADK_URL)$(NC)"
	@echo "$(YELLOW)💡 Press Ctrl+C to stop$(NC)"
	@which adk > /dev/null 2>&1 || (echo "$(RED)❌ ADK not found. Use 'make install' or 'make run-uvicorn'$(NC)" && exit 1)
	cd app && adk web

dev-uvicorn: ## Run uvicorn server and open browser (recommended)
	@echo "$(GREEN)🔧 Starting development environment (uvicorn)...$(NC)"
	@echo "$(BLUE)1️⃣  Starting uvicorn server$(NC)"
	@echo "$(BLUE)2️⃣  Opening browser in 3 seconds$(NC)"
	@(sleep 3 && $(MAKE) open-uvicorn) &
	@$(MAKE) run-uvicorn

dev-adk: ## Run ADK web interface and open browser
	@echo "$(GREEN)🔧 Starting development environment (ADK)...$(NC)"
	@echo "$(BLUE)1️⃣  Starting ADK web server$(NC)"
	@echo "$(BLUE)2️⃣  Opening browser in 3 seconds$(NC)"
	@(sleep 3 && $(MAKE) open-adk) &
	@$(MAKE) run-adk

open-uvicorn: ## Open browser to uvicorn interface
	@echo "$(GREEN)🌐 Opening browser to $(UVICORN_URL)...$(NC)"
	@$(BROWSER_CMD) $(UVICORN_URL) 2>/dev/null || echo "$(YELLOW)⚠ Could not open browser. Please visit: $(UVICORN_URL)$(NC)"

open-adk: ## Open browser to ADK interface
	@echo "$(GREEN)🌐 Opening browser to $(ADK_URL)...$(NC)"
	@$(BROWSER_CMD) $(ADK_URL) 2>/dev/null || echo "$(YELLOW)⚠ Could not open browser. Please visit: $(ADK_URL)$(NC)"

stop: ## Stop running servers
	@echo "$(GREEN)🛑 Stopping servers...$(NC)"
	@pkill -f "uvicorn main:app" 2>/dev/null && echo "$(GREEN)✓ Stopped uvicorn server$(NC)" || echo "$(YELLOW)⚠ No uvicorn server running$(NC)"
	@pkill -f "adk web" 2>/dev/null && echo "$(GREEN)✓ Stopped ADK server$(NC)" || echo "$(YELLOW)⚠ No ADK server running$(NC)"

clean: ## Clean up temporary files and caches
	@echo "$(GREEN)🧹 Cleaning up...$(NC)"
	@find . -name "*.pyc" -delete 2>/dev/null || true
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name ".DS_Store" -delete 2>/dev/null || true
	@find app -name "*.log" -delete 2>/dev/null || true
	@echo "$(GREEN)✅ Cleanup complete$(NC)"

deps: install ## Alias for install

check: status ## Alias for status

status: ## Show comprehensive project status
	@echo "$(BLUE)═══ 📊 agents.kelly Status ═══$(NC)"
	@echo ""
	@echo "$(GREEN)📁 Project Structure:$(NC)"
	@ls -la | grep -E "(app|chatty-kelly|Makefile|README)" || true
	@echo ""
	@echo "$(GREEN)🖥️  Environment:$(NC)"
	@echo "  OS: $(UNAME_S)"
	@echo "  Browser: $(BROWSER_CMD)"
	@echo "  Working Dir: $(PWD)"
	@echo ""
	@echo "$(GREEN)🌐 Server Configuration:$(NC)"
	@echo "  Uvicorn Port: $(UVICORN_PORT)"
	@echo "  Uvicorn URL:  $(UVICORN_URL)"
	@echo "  ADK Port:     $(ADK_PORT)"
	@echo "  ADK URL:      $(ADK_URL)"
	@echo ""
	@echo "$(GREEN)🔧 Dependencies:$(NC)"
	@pip show google-adk > /dev/null 2>&1 && echo "  ✅ google-adk installed" || echo "  ❌ google-adk missing"
	@which uvicorn > /dev/null 2>&1 && echo "  ✅ uvicorn available" || echo "  ❌ uvicorn missing"
	@which adk > /dev/null 2>&1 && echo "  ✅ adk available" || echo "  ⚠️  adk not found (optional)"
	@which python > /dev/null 2>&1 && echo "  ✅ python available" || echo "  ❌ python missing"
	@echo ""
	@echo "$(GREEN)📂 App Directory:$(NC)"
	@test -d app && echo "  ✅ app/ directory exists" || echo "  ❌ app/ directory missing"
	@test -f app/.env && echo "  ✅ app/.env exists" || echo "  ⚠️  app/.env missing"
	@test -f app/main.py && echo "  ✅ app/main.py exists" || echo "  ❌ app/main.py missing"
	@test -d app/static && echo "  ✅ app/static/ exists" || echo "  ❌ app/static/ missing"
	@echo ""
	@echo "$(GREEN)🔄 Running Processes:$(NC)"
	@ps aux | grep -E "(uvicorn main:app|adk web)" | grep -v grep || echo "  ⚠️  No servers currently running"
	@echo ""
	@echo "$(GREEN)🎯 Agent Info:$(NC)"
	@echo "  Main Agent: google_search_agent (app/google_search_agent/agent.py)"
	@echo "  Model: gemini-2.0-flash-exp"
	@echo "  Features: Google Search, Audio Streaming, Real-time Chat"
	@echo "  Tools: google_search" 