# Configure PaperTrail
PaperTrail.config.version_limit = 10

# Enable request tracking
PaperTrail.request.enabled = true

PaperTrail.request.whodunnit = ->(controller) { controller&.current_user&.id }
PaperTrail.request.controller_info = ->(controller) {
    {
    ip: controller&.request&.remote_ip,
    user_agent: controller&.request&.user_agent
    }
}
