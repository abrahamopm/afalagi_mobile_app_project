import mongoose, { Document, Schema } from 'mongoose';

export interface IClient extends Document {
  user: mongoose.Types.ObjectId;
  name: string;
  phone: string;
  priority: 'VIP' | 'HIGH' | 'MODERATE' | 'LOW';
  interest: number; // 1-5
  area?: string;
  budget?: string;
  image?: string;
  tags: string[];
  createdAt: Date;
}

const ClientSchema: Schema = new Schema({
  user: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  name: {
    type: String,
    required: [true, 'Please add a client name'],
    trim: true,
  },
  phone: {
    type: String,
    required: [true, 'Please add a phone number'],
  },
  priority: {
    type: String,
    enum: ['VIP', 'HIGH', 'MODERATE', 'LOW'],
    default: 'MODERATE',
  },
  interest: {
    type: Number,
    min: 1,
    max: 5,
    default: 3,
  },
  area: {
    type: String,
    default: '',
  },
  budget: {
    type: String,
    default: '',
  },
  image: {
    type: String,
    default: 'assets/images/generic_avatar.png',
  },
  tags: {
    type: [String],
    default: [],
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

export default mongoose.model<IClient>('Client', ClientSchema);
