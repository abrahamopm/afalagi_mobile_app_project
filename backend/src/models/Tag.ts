import mongoose, { Document, Schema } from 'mongoose';

export interface ITag extends Document {
  user: mongoose.Types.ObjectId;
  name: string;
  color: string;
  createdAt: Date;
}

const TagSchema: Schema = new Schema({
  user: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  name: {
    type: String,
    required: [true, 'Please add a tag name'],
    trim: true,
  },
  color: {
    type: String,
    default: '#1B385E',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

TagSchema.index({ user: 1, name: 1 }, { unique: true });

export default mongoose.model<ITag>('Tag', TagSchema);
