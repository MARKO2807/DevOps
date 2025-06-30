import './RefreshButton.css'

function RefreshButton({ onRefresh, loading }) {
  return (
    <div className="controls">
      <button 
        onClick={onRefresh} 
        disabled={loading}
        className="refresh-btn"
      >
        {loading ? '🔄 Loading...' : '🔄 Refresh Data'}
      </button>
    </div>
  )
}

export default RefreshButton 